require IEx

defmodule HelloPhoenix.VideoController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Video
  alias HelloPhoenix.User

  plug :scrub_params, "video" when action in [:create]


  def index(conn, %{"format" => "json"}) do
    render(conn, "index.json", videos: videos_all_join )
  end

  def index(conn, _params) do
    render(conn, "index.html", videos: videos_all_join)
  end

  defp videos_all_join do
    Video |> Video.join |> Repo.all
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

  def show(conn, %{"id" => id, "format" => "json"}) do
    render(conn, "show.json", video: video_get_join(id))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", video: video_get_join(id))
  end

  defp video_get_join(id) do
    Video |> Video.join |> Repo.get!(id)
  end

  def edit(conn, %{"id" => id}) do
    video = Video |> Repo.get!(id)
    changeset = Video.changeset(video)
    render(conn, "edit.html",
      video: video,
      changeset: changeset,
      users: users_list
    )
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Repo.get!(Video, id)
    changeset = Video.changeset(video, video_params)
    case Repo.update(changeset) do
      {:ok, video } ->
        conn
        |> put_flash(:info, "Video update successfully")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html",
          video: video,
          changeset: changeset,
          users: users_list
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    Repo.delete!(video)
    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp users_list() do
    users = User |> Repo.all
    users_list(users)
  end

  defp users_list(users) do
    for e <- users, into: %{}, do: { e.name, e.id }
  end
end
