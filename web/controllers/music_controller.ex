defmodule HelloPhoenix.MusicController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Music

  plug :scrub_params, "music" when action in [:create, :update]

  def index(conn, _params) do
    musics = Repo.all(Music)
    render(conn, "index.json", musics: musics)
  end

  def create(conn, %{"music" => music_params}) do
    changeset = Music.changeset(%Music{}, music_params)

    case Repo.insert(changeset) do
      {:ok, music} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", music_path(conn, :show, music))
        |> render("show.json", music: music)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    music = Repo.get!(Music, id)
    render(conn, "show.json", music: music)
  end

  def update(conn, %{"id" => id, "music" => music_params}) do
    music = Repo.get!(Music, id)
    changeset = Music.changeset(music, music_params)

    case Repo.update(changeset) do
      {:ok, music} ->
        render(conn, "show.json", music: music)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    music = Repo.get!(Music, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(music)

    send_resp(conn, :no_content, "")
  end
end
