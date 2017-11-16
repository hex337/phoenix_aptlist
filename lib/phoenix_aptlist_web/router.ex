defmodule PhoenixAptlistWeb.Router do
  use PhoenixAptlistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixAptlistWeb do
    pipe_through :api

    post "/slack-users/create", UserController, :from_slack
    post "/slack-users/list", UserController, :index_from_slack
    get "/slack-users/list", UserController, :index_from_slack
    post "/slack-users/groups", UserController, :groups
    post "/slack-users/delete", UserController, :delete_from_slack

    resources "/users", UserController, except: [:new, :edit]
  end
end
