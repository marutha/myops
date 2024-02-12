defmodule MyOps.Account.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_tokens" do
    field :game_code, :string
    field :token, Ecto.UUID
    field :ttl, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_token, attrs) do
    attrs = Map.put(attrs, "ttl", 86400)
    user_token
    |> cast(attrs, [:token, :ttl, :game_code])
    |> validate_required([:token, :ttl, :game_code])
  end
end
