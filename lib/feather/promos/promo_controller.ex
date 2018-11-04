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

  def index(conn, params) do
    {status, response} =
      case PromoModel.get_codes(params) do
        {:ok, resp} -> {200, resp}
        {:error, resp} -> {400, resp}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

  def get_code_details(conn, params) do
    {status, response} =
      case PromoModel.get_code_details(params) do
        {:ok, resp} -> {200, resp}
        {:error, resp} -> {400, resp}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

  def create(conn, params) do
    {status, response} =
      case PromoModel.generate_codes(params) do
        {:ok, resp} -> {200, resp}
        {:error, error} -> {400, error}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

  def validate_code(conn, params) do
    {status, response} =
      case PromoModel.validate_code(params) do
        {:ok, resp} -> {200, resp}
        {:error, error} -> {400, error}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

  def activate_code(conn, params) do
    id = params["id"]
    {status, response} =
      case PromoModel.activate_code(id) do
        {:ok, resp} -> {200, resp}
        {:error, error} -> {400, error}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

  def deactivate_code(conn, params) do
    id = params["id"]

    {status, response} =
      case PromoModel.deactivate_code(id) do
        {:ok, resp} -> {200, resp}
        {:error, error} -> {400, error}
      end
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{resp: response}))
  end

end
