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
    LocationUtils,
    PromoUtils
  }

  #assuming offer is valid for 15 days it can be configured
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
  module to give code details list by limit & offset
  """
  def get_codes(params) do
    limit = params["limit"] || "20"
    offset = params["offset"] || "0"
    type = params["type"] || true

    query = (
      from p in PromoModel,
      limit: ^String.to_integer(limit),
      offset: ^String.to_integer(offset),
      where: p.is_active == ^type,
      select: p
    )

    resp =
      query
      |> Repo.all()
      |> Enum.map(fn x->
        x |> Feather.PromoUtils.pack_code_json
      end)
    {:ok, resp}
  end

  @doc """
    give code details when u pass code
    input -> %{"code"=> code}
    output -> %{:ok, resp} || {:error, nil}
  """
  def get_code_details(%{"code"=> code}) do
    query =
      from u in PromoModel,
      where: u.code == ^code,
      select: u

    resp =
      query
      |> Repo.one()
      |> PromoUtils.pack_code_json()

    case resp do
      nil -> {:error, nil}
      "" -> {:error, "code invalid"}
      _ -> {:ok, resp}
    end
  end


  @doc """
    give active & valid non expired code details when u pass code
    input -> code
    output -> {:ok, resp} || {:error, nil}
  """
  def get_valid_code_details(code) do
    query =
      from u in PromoModel,
      where: u.code == ^code and u.is_active == true and u.expire_time > ^Timex.now(),
      select: u

    resp =
      query
      |> Repo.one()

    case resp do
      nil -> {:error, nil}
      _ -> {:ok, resp |> PromoUtils.pack_code_json()}
    end
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
    activate_code if it is deactivated
    input -> id
    output -> {:ok, resp} || {:error, resp}
  """
  def activate_code(id) do
    update_code_status(id, true)
  end

  @doc """
    deactivate_code if it is active
    input -> id
    output -> {:ok, resp} || {:error, resp}
  """
  def deactivate_code(id) do
    update_code_status(id, false)
  end

  def update_code_status(id, status) do
    query =
      from(
        p in PromoModel,
        where: p.id == ^id,
        update: [set: [is_active: ^status]]
      )

    case Repo.update_all(query, []) do
      {1, _} -> {:ok, "success"}
      {0, _} -> {:error, "invalid code"}
      _ -> {:error, "some error occured, please try again"}
    end

  end

  def get_data do
    %{
      "code"=> "BAF0CEC8",
      "radius"=> 50,
      "source"=> %{"lat"=> 27.8974, "long"=> 78.088},
      "destination"=> %{"lat"=> 28.4070, "long"=> 77.8498}
    }
  end

  @doc """
    validate code for source & destination
    input:
    %{
        "code"=> "BAF0CEC8",
        "radius"=> 50,
        "source"=> %{"lat"=> 27.8974, "long"=> 78.088},
        "destination"=> %{"lat"=> 28.4070, "long"=> 77.8498}
      }
    output: {:ok, response} || {:error, response}
  """
  def validate_code(params) do
    code = params["code"]
      case resp = code |> get_valid_code_details do
        {:ok, code_details} ->
          radius = code_details["radius"]
          validate_source_task = Task.async(fn -> params["source"] |> within(radius, code) end)
          validate_destination_task = Task.async(fn -> params["destination"] |> within(radius, code) end)

          case {Task.await(validate_source_task), Task.await(validate_destination_task)} do
            {true, true} -> {:ok, "valid code for source & destination"}
            {true , false} -> {:error, "dropping location outside of event area"}
            {false, true} -> {:error, "pickup outside of event area"}
            {false, false} -> {:error, "pickup and drop outside of event area"}
            {_, _} -> {:error, "unknown error please try again"}
          end
          {:error, _} ->
            {:error, "invalid code"}
          _ ->
            {:error, resp}
      end
  end

  @doc """
  module to give back code if our source or destination falls inside the radius
  """
  def within(%{"long"=> longitude, "lat"=> latitude}, radius, code) do
    event_coordinates = %Geo.Point{coordinates: {longitude, latitude}}
    radius = Decimal.mult(radius, Decimal.new(1000)) |> Decimal.to_float
    query =
      from p in PromoModel,
      where: fragment("st_distance_sphere(?, ?)  < ?", p.event_location, ^event_coordinates, ^radius)
      and p.code == ^code and p.is_active == ^true and p.expire_time > ^Timex.now(),
      select: count(p.code)
    case Repo.one(query) do
      0 -> false
      nil -> false
      _ -> true
    end
  end

  #sample data
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

  @doc """
  generate codes in DB for your promotion
  """
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
          event_id: nil,
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
    {:ok, "all is well, codes generated"}
  end

  defp get_promo_code_list(total_promo_num), do:
    total_promo_num
    |> AppUtils.generate_promos

  defp extract_lat_long(params), do:
    LocationUtils.extract_lat_long(params)


end