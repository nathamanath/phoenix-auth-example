defmodule AuthWeb.Router do
  use AuthWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug OneplaceWeb.Plug.AuthAccessPipeline
  end

  scope "/", AuthWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", AuthWeb do
    pipe_through :api

    scope "/auth" do
      post "/identity/callback", AuthenticationController, :identity_callback
    end

    pipe_through :authenticated

    resources "/users", UserController, except: [:new, :edit]
  end
end
