defmodule HelloPhoenix.Repo.Migrations.CreateMusic do
  use Ecto.Migration

  def change do
    create table(:musics) do
      add :title, :string
      add :author, :string
      add :link, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:musics, [:user_id])

  end
end
