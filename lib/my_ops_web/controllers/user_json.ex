defmodule MyOpsWeb.UserJSON do
  alias MyOps.Account.User
  alias MyOpsWeb.UserTokenJSON

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def balance(%{user: user}) do
    %{
      id: user.id,
      currency: user.currency,
      balance: user.balance
     }
  end

  def user_token(user_token) do
    UserTokenJSON.show(user_token)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      country: user.country,
      sex: user.sex,
      affiliate_id: user.affiliate_id,
      balance: user.balance,
      currency: user.currency,
      sub_partner_id: user.sub_partner_id,
      registration_date: user.registration_date,
      birth_date: user.birth_date,
      jurisdiction: user.jurisdiction
    }
  end
end
