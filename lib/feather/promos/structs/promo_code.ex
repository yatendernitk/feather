defmodule Feather.PromoCode do
  defstruct [
    :id,
    :code,
    :description,
    :created_at,
    :updated_at,
    :is_active,
    :expire_at,
    :active_at,
    :amount,
    :event_id,
    :currency,
    :event_location,
    :radius
  ]



end