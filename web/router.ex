defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

  pipeline :browser do
    plug PathFormat,  %{ key: "format", id: "id" }
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug PathFormat, %{ key: "format", id: "id" }
    plug :accepts, ["json"]
  end

  scope "/", HelloPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/videos", VideoController
  end

  scope "/api", HelloPhoenix do
    pipe_through :api
    resources "/musics", MusicController, except: [:new, :edit]
  end

end
