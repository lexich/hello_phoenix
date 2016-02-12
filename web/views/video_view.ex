defmodule HelloPhoenix.VideoView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{videos: videos}) do
    %{ data: render_many(videos, HelloPhoenix.VideoView, "video.json")}
  end

  def render("show.json", %{video: video}) do
    %{ data: render_one(video, HelloPhoenix.VideoView, "video.json")}
  end

  def render("video.json", %{video: video}) do
    %{
      id: video.id,
      name: video.name,
      description: video.description,
      likes: video.likes,
      views: video.views,
      approved_at: video.approved_at,
      user_id: video.user_id
    }
  end
end
