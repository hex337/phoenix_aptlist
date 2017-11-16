defmodule PhoenixAptlist.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixAptlist.Users.User


  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
