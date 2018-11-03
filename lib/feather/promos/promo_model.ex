defmodule Feather.PromoModel do
  @moduledoc """
  DB access layer for promotional codes
  """
  use Feather, :model
  import Ecto.Query
  alias Feather.{Repo, PromoModel}

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
    |> cast(params, [:code, :description, :is_active, :type, :amount, :event_location])
    |> validate_required([:code, :description, :is_active, :type, :amount, :event_location])
  end

  @doc """
  module to give back code if our source or destination falls inside the radius
  """
  def within(%{long: longitude, lat: latitude}, radius, code) do
    event_coordinates = %Geo.Point{coordinates: {longitude, latitude}}
    radius = radius * 1000
    query = from p in PromoModel, where: fragment("st_distance_sphere(?, ?)  < ?", p.event_location, ^event_coordinates, ^radius)
      and p.code == ^code and p.is_active == ^true,
    select: count(p.code)
    Repo.one(query)
  end

end