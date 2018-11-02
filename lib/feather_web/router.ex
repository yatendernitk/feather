defmodule Feather.Router do
  use FeatherWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" Feather do
    pipe_through :api
    
  end

  scope "/api", Feather do
    pipe_through :api
    forward "/promo", PromoRouter
  end
end
