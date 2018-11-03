defmodule Feather.PromoCode do
  defstruct [
    :code, :description, :is_active, :type, :amount, :event_location, :event_id, :expire_time, :activation_time, :radius
  ]
end
