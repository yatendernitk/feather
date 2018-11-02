defmodule Feather do
  @moduledoc """
  Feather keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def controller do
    quote do
      use Phoenix.Controller
      import Plug.Conn
      # import FeatherWeb.Router.Helpers
      alias FeatherWeb.Router.Helpers, as: Routes
      import FeatherWeb.Gettext
    end
  end
@doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
