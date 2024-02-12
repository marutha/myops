defmodule MyOps.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :country, :string
      add :jurisdiction, :string
      add :sub_partner_id, :string
      add :birth_date, :date
      add :registration_date, :date
      add :sex, :string
      add :affiliate_id, :string
      add :currency, :string
      add :balance, :float

      timestamps(type: :utc_datetime)
    end
  end
end
