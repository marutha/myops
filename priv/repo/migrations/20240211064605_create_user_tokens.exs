defmodule MyOps.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :uuid
      add :ttl, :integer
      add :game_code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
