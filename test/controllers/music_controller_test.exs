defmodule HelloPhoenix.MusicControllerTest do
  use HelloPhoenix.ConnCase

  alias HelloPhoenix.Music
  @valid_attrs %{author: "some content", link: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, music_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    music = Repo.insert! %Music{}
    conn = get conn, music_path(conn, :show, music)
    assert json_response(conn, 200)["data"] == %{"id" => music.id,
      "title" => music.title,
      "author" => music.author,
      "link" => music.link,
      "user_id" => music.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, music_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, music_path(conn, :create), music: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Music, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, music_path(conn, :create), music: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    music = Repo.insert! %Music{}
    conn = put conn, music_path(conn, :update, music), music: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Music, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    music = Repo.insert! %Music{}
    conn = put conn, music_path(conn, :update, music), music: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    music = Repo.insert! %Music{}
    conn = delete conn, music_path(conn, :delete, music)
    assert response(conn, 204)
    refute Repo.get(Music, music.id)
  end

end
