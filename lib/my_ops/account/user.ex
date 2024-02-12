defmodule MyOps.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :affiliate_id, :string
    field :balance, :float
    field :birth_date, :date
    field :country, :string
    field :currency, :string
    field :jurisdiction, :string
    field :name, :string
    field :registration_date, :date
    field :sex, :string
    field :sub_partner_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :country,
      :jurisdiction,
      :sub_partner_id,
      :birth_date,
      :registration_date,
      :sex,
      :affiliate_id,
      :currency,
      :balance
    ])
    |> validate_required([
      :name,
      :country,
      :jurisdiction,
      :sub_partner_id,
      :birth_date,
      :registration_date,
      :sex,
      :affiliate_id,
      :currency,
      :balance
    ])
  end
end
