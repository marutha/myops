defmodule MyOpsWeb.UserTokenController do
  use MyOpsWeb, :controller

  alias MyOps.Account
  alias MyOps.Account.UserToken

  action_fallback MyOpsWeb.FallbackController

  def index(conn, _params) do
    user_tokens = Account.list_user_tokens()
    render(conn, :index, user_tokens: user_tokens)
  end

  def create(conn, %{"user_token" => user_token_params}) do
    with {:ok, %UserToken{} = user_token} <- Account.create_user_token(user_token_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/user_tokens/#{user_token}")
      |> render(:show, user_token: user_token)
    end
  end

  def show(conn, %{"id" => id}) do
    user_token = Account.get_user_token!(id)
    render(conn, :show, user_token: user_token)
  end

  def update(conn, %{"id" => id, "user_token" => user_token_params}) do
    user_token = Account.get_user_token!(id)

    with {:ok, %UserToken{} = user_token} <- Account.update_user_token(user_token, user_token_params) do
      render(conn, :show, user_token: user_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_token = Account.get_user_token!(id)

    with {:ok, %UserToken{}} <- Account.delete_user_token(user_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
