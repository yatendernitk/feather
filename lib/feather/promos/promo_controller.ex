defmodule Feather.PromoController do
  @moduledoc """
  promo controller file which will handle interfacing
  between db layer and router
  """
  alias Feather.Router.Helpers, as: Routes
  use Feather, :controller
  alias Feather.{
    PromoModel
  }

  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!("yo"))
  end

  def generate_codes(conn, params) do
    resp = PromoModel.generate_codes(params)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{resp: resp}))
  end

end
