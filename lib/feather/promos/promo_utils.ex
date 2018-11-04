defmodule Feather.PromoUtils do
  def pack_code_json(nil) do
    nil
  end

  def pack_code_json("") do
    %{}
  end

  def pack_code_json(row) do
    %{
      "activation_time"=> row.activation_time,
      "amount"=> row.amount,
      "code"=> row.code,
      "description"=> row.description,
      "event_id"=> row.event_id,
      "expire_time"=> row.expire_time,
      "id"=> row.id,
      "is_active"=> row.is_active,
      "radius"=> row.radius,
      "type"=> row.type,
      "inserted_at"=> row.inserted_at,
      "updated_at"=> row.updated_at,
      "event_location"=> pack_coordinates(row.event_location)
    }
  end

  defp pack_coordinates(event_location) do
    case event_location.coordinates do
      {long, lat} ->
        %{
          "lat"=> lat,
          "long"=> long
        }
        _ ->
          %{
            "lat"=> nil,
            "long"=> nil
          }
    end
  end

end