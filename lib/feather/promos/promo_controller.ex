defmodule Feather.PromoController do
  @moduledoc """
  promo controller file which will handle interfacing
  between db layer and router
  """
  alias Feather.Router.Helpers, as: Routes
  use Feather, :controller

  def index(conn, params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!("yo"))
  end

end