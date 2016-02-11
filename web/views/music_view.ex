defmodule HelloPhoenix.MusicView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{musics: musics}) do
    %{data: render_many(musics, HelloPhoenix.MusicView, "music.json")}
  end

  def render("show.json", %{music: music}) do
    %{data: render_one(music, HelloPhoenix.MusicView, "music.json")}
  end

  def render("music.json", %{music: music}) do
    %{id: music.id,
      title: music.title,
      author: music.author,
      link: music.link,
      user_id: music.user_id}
  end
end
