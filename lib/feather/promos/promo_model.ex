defmodule Feather.PromoModel do
  @moduledoc """
  DB access layer for promotional codes
  """
  use Feather, :model

  @primary_key {:id, :id, autogenerate: true}
  schema "promo_codes" do
    field :code, :string
    field :description, :string
    field :is_active, :boolean, default: true
    field :type, :string
    field :amount, :decimal
    field :event_location, Geo.PostGIS.Geometry
    # field :expire_time, Timex.Ecto.DateTime
    # field :activation_time, Timex.Ecto.DateTime

    # timestamps()
  end

   @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :description, :is_active, :type, :amount, :event_location])
    |> validate_required([:code, :description, :is_active, :type, :amount, :event_location])
  end
end