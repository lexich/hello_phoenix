defmodule HelloPhoenix.VideoController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Video
  alias HelloPhoenix.User

  plug :scrub_params, "video" when action in [:create]

  def index(conn, _params) do
    videos = Video |> Video.join |> Repo.all

    Enum.each videos, fn video ->
      IO.puts "#####"
      IO.inspect video
    end
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render(conn, "new.html", changeset: changeset, users: users_list )
  end

  def create(conn, %{"video" => video_params}) do
    changeset = Video.changeset(%Video{}, video_params)
    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          users: users_list
        )
    end
  end

  defp users_list() do
    users = User |> Repo.all
    users_list(users)
  end

  defp users_list(users) do
    for e <- users, into: %{}, do: { e.name, e.id }
  end
end
