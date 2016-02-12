defmodule HelloPhoenix.VideoControllerTest do
  use HelloPhoenix.ConnCase

  alias HelloPhoenix.Video
  alias HelloPhoenix.User
  @valid_attrs %{approved_at: "2020-04-17 14:00:00", description: "some content", likes: 42, name: "some content", views: 42 }
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Videos"
  end

  test "list all entries on index with json", %{conn: conn} do
    conn = get conn, video_path(conn, :index), format: "json"
    response = json_response(conn, 200)
    assert response["data"] == []
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, video_path(conn, :new)
    assert html_response(conn, 200) =~ "New Video"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    attrs = %{approved_at: "2010-04-17 14:00:00", description: "some content", likes: 42, name: "some content", views: 42, user_id: user.id }
    conn = post conn, video_path(conn, :create), video: attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by(Video, attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "New Video"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{ user_id: user.id }
    conn = get conn, video_path(conn, :show, video)
    assert html_response(conn, 200) =~ "Show Video"
  end

  test "shows chosen resource with json", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{
      user_id: user.id,
      name: "some content",
      description: "some content",
      likes: 42,
      views: 42
    }
    conn = get conn, video_path(conn, :show, video), format: "json"
    response = json_response(conn, 200)
    assert response["data"] === %{
      "id" => video.id,
      "name" => video.name,
      "description" => video.description,
      "likes" => video.likes,
      "views" => video.views,
      "user_id" => video.user_id,
      "approved_at" => video.approved_at
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, video_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{ user_id: user.id }
    conn = get conn, video_path(conn, :edit, video)
    assert html_response(conn, 200) =~ "Edit Video"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{ user_id: user.id }
    approved_at = %{ year: 2020, month: 10, day: 1, hour: 5, min: 0 }
    attrs = %{approved_at: approved_at, description: "some content", likes: 42, name: "some content", views: 42 }
    conn = put conn, video_path(conn, :update, video), video: attrs

    assert redirected_to(conn) == video_path(conn, :show, video)
    assert Repo.get_by(Video, attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{ user_id: user.id }
    conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Video"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    video = Repo.insert! %Video{ user_id: user.id }
    conn = delete conn, video_path(conn, :delete, video)
    assert redirected_to(conn) == video_path(conn, :index)
    refute Repo.get(Video, video.id)
  end
end
