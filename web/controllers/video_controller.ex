defmodule HelloPhoenix.VideoController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Video

  def index(conn, _params) do
    videos = Video |> Video.join |> Repo.all
    render(conn, "index.html", videos: videos)
  end
end
