defmodule HelloPhoenix.Music do
  use HelloPhoenix.Web, :model

  schema "musics" do
    field :title, :string
    field :author, :string
    field :link, :string
    belongs_to :user, HelloPhoenix.User

    timestamps
  end

  @required_fields ~w(title author link)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
