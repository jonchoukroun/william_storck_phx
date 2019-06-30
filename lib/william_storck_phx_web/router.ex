defmodule WilliamStorckPhxWeb.Router do
  use WilliamStorckPhxWeb, :router

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

  # Must be logged in
  scope "/admin", WilliamStorckPhxWeb.Admin, as: :admin do
    pipe_through [:browser, WilliamStorckPhxWeb.Plugs.Auth]

    get "/", LandingController, :index

    resources "/users", UserController

    delete "/login", SessionController, :delete
  end

  # Must be logged out
  scope "/admin", WilliamStorckPhxWeb.Admin, as: :admin do
    pipe_through [:browser, WilliamStorckPhxWeb.Plugs.Guest]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", WilliamStorckPhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    resources "/paintings", PaintingsController, only: [:index, :show]
    resources "/upload", UploadController, only: [:create, :new]

    get "/contact", ContactController, :index
    post "/contact", ContactController, :capture_email

    get "/sitemap", SitemapController, :index
    get "/privacy", PrivacyController, :index


    get "/*path", PaintingsController, :index
  end
end
