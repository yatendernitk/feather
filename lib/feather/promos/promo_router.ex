defmodule Feather.PromoRouter do
  @moduledoc """
  module to route the promo related requestes
  """
  use FeatherWeb, :router
  alias Feather.{
    PromoController
  }

  get "/", PromoController, :index
  get "/:code", PromoController, :get_code_details
  post "/", PromoController, :create
  put "/", PromoController, :activate_code
  delete "/", PromoController, :deactivate_code
end