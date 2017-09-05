defmodule Feelbot.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Feelbot.Accounts.User


  schema "users" do
    field :avatar, :string
    field :display_name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:avatar, :display_name, :username])
    |> validate_required([:username])
  end
end
