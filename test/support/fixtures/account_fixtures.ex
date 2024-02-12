defmodule MyOps.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyOps.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        affiliate_id: "some affiliate_id",
        balance: 120.5,
        birth_date: ~D[2024-02-10],
        country: "some country",
        currency: "some currency",
        jurisdiction: "some jurisdiction",
        name: "some name",
        registration_date: ~D[2024-02-10],
        sex: "some sex",
        sub_partner_id: "some sub_partner_id"
      })
      |> MyOps.Account.create_user()

    user
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        game_code: "some game_code",
        token: "7488a646-e31f-11e4-aace-600308960662",
        ttl: 42
      })
      |> MyOps.Account.create_user_token()

    user_token
  end
end
