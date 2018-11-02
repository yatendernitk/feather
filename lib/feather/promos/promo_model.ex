defmodule Feather.PromoModel do
  @moduledoc """
  DB access layer for promotional codes
  """
  use Feather, :model

  import Ecto.Query, only: [from: 2]

  @primary_key {:id, :id, autogenerate: true}
  schema "promo_codes" do
    field :code, :string
    field :description, :string
    field :is_active, :boolean, default: true
    field :coupon_type, :string
    field :amount, :decimal
    field :expire_time, Timex.Ecto.DateTime
    field :activation_time, Timex.Ecto.DateTime

    timestamps()
  end

  def get(module, id) do

  end
end