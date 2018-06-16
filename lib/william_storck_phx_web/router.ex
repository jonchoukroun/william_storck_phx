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

  scope "/", WilliamStorckPhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    resources "/paintings", PaintingsController, only: [:index, :show]

    get "/contact", ContactController, :index
    post "/contact", ContactController, :capture_email

    get "/sitemap", SitemapController, :index
    get "/privacy", PrivacyController, :index
  end

end
