defmodule MyOpsWeb.UserControllerTest do
  use MyOpsWeb.ConnCase

  import MyOps.AccountFixtures

  @create_attrs %{
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
  }
  @update_attrs %{
    affiliate_id: "some updated affiliate_id",
    balance: 456.7,
    birth_date: ~D[2024-02-11],
    country: "some updated country",
    currency: "some updated currency",
    jurisdiction: "some updated jurisdiction",
    name: "some updated name",
    registration_date: ~D[2024-02-11],
    sex: "some updated sex",
    sub_partner_id: "some updated sub_partner_id"
  }
  @invalid_attrs %{
    affiliate_id: nil,
    balance: nil,
    birth_date: nil,
    country: nil,
    currency: nil,
    jurisdiction: nil,
    name: nil,
    registration_date: nil,
    sex: nil,
    sub_partner_id: nil
  }

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/users")
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/users/new")
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/users/#{id}"

      conn = get(conn, ~p"/users/#{id}")
      assert html_response(conn, 200) =~ "User #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/#{user}/edit")
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/users/#{user}"

      conn = get(conn, ~p"/users/#{user}")
      assert html_response(conn, 200) =~ "some updated affiliate_id"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/users/#{user}")
      assert redirected_to(conn) == ~p"/users"

      assert_error_sent 404, fn ->
        get(conn, ~p"/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
