defmodule Feather.PromoModel do
  @moduledoc """
  DB access layer for promotional codes
  """
  use Feather, :model
  import Ecto.Query
  alias Feather.{
    Repo,
    PromoModel,
    AppUtils,
    LocationUtils
  }

  @offer_days 15

  @primary_key {:id, :id, autogenerate: true}
  schema "promo_codes" do
    field :code, :string
    field :description, :string
    field :is_active, :boolean, default: true
    field :type, :string, default: "unique"
    field :amount, :decimal
    field :event_location, Geo.PostGIS.Geometry
    field :event_id
    field :expire_time, Timex.Ecto.DateTime
    field :activation_time, Timex.Ecto.DateTime, default: Timex.now
    field :radius, :decimal
    timestamps()
  end

   @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :description, :is_active, :type, :amount, :event_location, :expire_time, :activation_time, :radius])
    |> validate_required([:code, :description, :is_active, :type, :amount, :event_location, :expire_time, :activation_time, :radius])
  end

  @doc """
  module to give back code if our source or destination falls inside the radius
  """
  def within(%{long: longitude, lat: latitude}, radius, code) do
    event_coordinates = %Geo.Point{coordinates: {longitude, latitude}}
    radius = radius * 1000
    query =
      from p in PromoModel,
      where: fragment("st_distance_sphere(?, ?)  < ?", p.event_location, ^event_coordinates, ^radius)
      and p.code == ^code and p.is_active == ^true,
      select: count(p.code)
    Repo.one(query)
  end

  def get_params() do
    %{
      "radius"=> 50,
      "promo_num"=> 50,
      "event_location"=> %{
        "lat"=> 28.2514,
        "long"=> 77.8539
      }
    }
  end

  def generate_codes(params) do
    radius = params["radius"]
    total_promo_num = params["promo_num"] || 1000
    description = params["description"] || "test code"
    activation_time = Timex.now()
    #assuming that promotional offer will run for 15 days
    expire_time = Timex.shift(activation_time, days: @offer_days)
    {long , lat} = extract_lat_long(params["event_location"])
    event_loc = %Geo.Point{coordinates: {long, lat}, srid: 4326}

    promo_code_list = total_promo_num |> get_promo_code_list

    promo_code_list
    |> Enum.map(fn x->
      Task.async(fn ->
        %{
          code: x,
          description: description || "offer code for rides",
          is_active: true,
          type: "unique",
          amount: 0.0,
          event_id: 1234,
          event_location: event_loc,
          radius: radius,
          expire_time: expire_time,
          activation_time: activation_time
        }
      end)
    end)
    |> Enum.map(fn x ->
      promo_code_item = Task.await(x)
      Feather.PromoModel.changeset(%Feather.PromoModel{}, promo_code_item)
        |> Feather.Repo.insert!()
    end)
  end


  defp get_promo_code_list(total_promo_num) do
    total_promo_num
    |> AppUtils.generate_promos
  end

  defp extract_lat_long(params), do:
    LocationUtils.extract_lat_long(params)

end
