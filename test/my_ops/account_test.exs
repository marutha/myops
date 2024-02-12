defmodule MyOps.AccountTest do
  use MyOps.DataCase

  alias MyOps.Account

  describe "users" do
    alias MyOps.Account.User

    import MyOps.AccountFixtures

    @invalid_attrs %{affiliate_id: nil, balance: nil, birth_date: nil, country: nil, currency: nil, jurisdiction: nil, name: nil, registration_date: nil, sex: nil, sub_partner_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{affiliate_id: "some affiliate_id", balance: 120.5, birth_date: ~D[2024-02-10], country: "some country", currency: "some currency", jurisdiction: "some jurisdiction", name: "some name", registration_date: ~D[2024-02-10], sex: "some sex", sub_partner_id: "some sub_partner_id"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.affiliate_id == "some affiliate_id"
      assert user.balance == 120.5
      assert user.birth_date == ~D[2024-02-10]
      assert user.country == "some country"
      assert user.currency == "some currency"
      assert user.jurisdiction == "some jurisdiction"
      assert user.name == "some name"
      assert user.registration_date == ~D[2024-02-10]
      assert user.sex == "some sex"
      assert user.sub_partner_id == "some sub_partner_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{affiliate_id: "some updated affiliate_id", balance: 456.7, birth_date: ~D[2024-02-11], country: "some updated country", currency: "some updated currency", jurisdiction: "some updated jurisdiction", name: "some updated name", registration_date: ~D[2024-02-11], sex: "some updated sex", sub_partner_id: "some updated sub_partner_id"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.affiliate_id == "some updated affiliate_id"
      assert user.balance == 456.7
      assert user.birth_date == ~D[2024-02-11]
      assert user.country == "some updated country"
      assert user.currency == "some updated currency"
      assert user.jurisdiction == "some updated jurisdiction"
      assert user.name == "some updated name"
      assert user.registration_date == ~D[2024-02-11]
      assert user.sex == "some updated sex"
      assert user.sub_partner_id == "some updated sub_partner_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "user_tokens" do
    alias MyOps.Account.UserToken

    import MyOps.AccountFixtures

    @invalid_attrs %{game_code: nil, token: nil, ttl: nil}

    test "list_user_tokens/0 returns all user_tokens" do
      user_token = user_token_fixture()
      assert Account.list_user_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert Account.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      valid_attrs = %{game_code: "some game_code", token: "7488a646-e31f-11e4-aace-600308960662", ttl: 42}

      assert {:ok, %UserToken{} = user_token} = Account.create_user_token(valid_attrs)
      assert user_token.game_code == "some game_code"
      assert user_token.token == "7488a646-e31f-11e4-aace-600308960662"
      assert user_token.ttl == 42
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()
      update_attrs = %{game_code: "some updated game_code", token: "7488a646-e31f-11e4-aace-600308960668", ttl: 43}

      assert {:ok, %UserToken{} = user_token} = Account.update_user_token(user_token, update_attrs)
      assert user_token.game_code == "some updated game_code"
      assert user_token.token == "7488a646-e31f-11e4-aace-600308960668"
      assert user_token.ttl == 43
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user_token(user_token, @invalid_attrs)
      assert user_token == Account.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = Account.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = Account.change_user_token(user_token)
    end
  end
end
