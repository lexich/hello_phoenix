defmodule HelloPhoenix.MusicTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.Music

  @valid_attrs %{author: "some content", link: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Music.changeset(%Music{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Music.changeset(%Music{}, @invalid_attrs)
    refute changeset.valid?
  end
end
