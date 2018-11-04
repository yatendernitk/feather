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
  post "/:code/validate", PromoController, :validate_code
  put "/:id", PromoController, :activate_code
  delete "/:id", PromoController, :deactivate_code

end
