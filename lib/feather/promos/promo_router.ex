defmodule Feather.PromoRouter do
  @moduledoc """
  module to route the promo related requestes
  """
  use FeatherWeb, :router

  get "/", Feather.PromoController, :index
end