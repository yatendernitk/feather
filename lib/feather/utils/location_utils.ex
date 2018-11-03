defmodule Feather.LocationUtils do
  def extract_lat_long(%{"lat"=> lat, "long"=> long}) do
    {long,lat}
  end
end