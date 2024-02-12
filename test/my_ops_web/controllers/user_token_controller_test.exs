defmodule MyOpsWeb.UserTokenControllerTest do
  use MyOpsWeb.ConnCase

  import MyOps.AccountFixtures

  alias MyOps.Account.UserToken

  @create_attrs %{
    game_code: "some game_code",
    token: "7488a646-e31f-11e4-aace-600308960662",
    ttl: 42
  }
  @update_attrs %{
    game_code: "some updated game_code",
    token: "7488a646-e31f-11e4-aace-600308960668",
    ttl: 43
  }
  @invalid_attrs %{game_code: nil, token: nil, ttl: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_tokens", %{conn: conn} do
      conn = get(conn, ~p"/api/user_tokens")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_token" do
    test "renders user_token when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_tokens", user_token: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_tokens/#{id}")

      assert %{
               "id" => ^id,
               "game_code" => "some game_code",
               "token" => "7488a646-e31f-11e4-aace-600308960662",
               "ttl" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_tokens", user_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_token" do
    setup [:create_user_token]

    test "renders user_token when data is valid", %{conn: conn, user_token: %UserToken{id: id} = user_token} do
      conn = put(conn, ~p"/api/user_tokens/#{user_token}", user_token: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_tokens/#{id}")

      assert %{
               "id" => ^id,
               "game_code" => "some updated game_code",
               "token" => "7488a646-e31f-11e4-aace-600308960668",
               "ttl" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_token: user_token} do
      conn = put(conn, ~p"/api/user_tokens/#{user_token}", user_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_token" do
    setup [:create_user_token]

    test "deletes chosen user_token", %{conn: conn, user_token: user_token} do
      conn = delete(conn, ~p"/api/user_tokens/#{user_token}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_tokens/#{user_token}")
      end
    end
  end

  defp create_user_token(_) do
    user_token = user_token_fixture()
    %{user_token: user_token}
  end
end
