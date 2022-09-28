defmodule CEvalApiWeb.Router do
  use CEvalApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CEvalApiWeb do
    pipe_through :api
  end
end
