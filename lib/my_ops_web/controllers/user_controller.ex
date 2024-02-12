defmodule MyOpsWeb.UserController do
  use MyOpsWeb, :controller

  alias ConCache
  alias Hammer

  alias MyOps.Account
  alias MyOps.Account.User
  alias MyOps.Account.UserToken

  def index(conn, _params) do
    show(conn, %{"id" => 1})
    # users = Account.list_users()
    # render(conn, :index, users: users)
  end

  def user_info(conn, _params) do
    show(conn, %{"id" => 1})
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_id = get_user(conn)
    case Hammer.check_rate("show:#{user_id}", 60_000, 5) do
      {:allow, _count} ->
        user = Account.get_user!(user_id)
        render(conn, :show, user: user)
      {:deny, _limit} ->
        render(conn, :error, reason: :limit_reached)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = get_user(conn)
    user = Account.get_user!(user_id)
    changeset = Account.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user_id = get_user(conn)
    user = Account.get_user!(user_id)

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def balance(conn, _params) do
    user_id = get_user(conn)
    case Hammer.check_rate("balance:#{user_id}", 60_000, 5) do
      {:allow, _count} ->
        user = Account.get_user!(user_id)
        render(conn, :balance, user: user)
      {:deny, _limit} ->
        render(conn, :error, reason: :limit_reached)
    end
  end

  def authorize(%{assigns: assigns} = conn, _params) do
    # %{"user_token_params" => user_token_params}
    user_id = get_user(conn)
    case Hammer.check_rate("authorize:#{user_id}", 60_000, 5) do
      {:allow, _count} ->
        %{params: params, request_uuid: uuid} = assigns
        user = Account.get_user!(user_id)
        with {:ok, %UserToken{} = user_token} <- Account.create_user_token(params) do
          IO.puts("params: #{inspect(user_token)}")
          render(conn, :user_token, user_token: user_token)
        true
          render(conn, :user, user: user)
        end
      {:deny, _limit} ->
        render(conn, :error, reason: :limit_reached)
    end

  end

  def transaction_win(%{assigns: assigns} = conn, _params) do
    user_id = get_user(conn)
    case Hammer.check_rate("transaction_win:#{user_id}", 60_000, 5) do
      {:allow, _count} ->
        user = Account.get_user!(user_id)
        %{params:  params } = assigns
        tx_id = Map.get(params, "transaction_uuid")
        amount = Map.get(params, "amount")
        case ConCache.get(:tx_cache, tx_id) do
          nil ->
            ConCache.put(:tx_cache, tx_id, %{tx_status: :pending, result: nil})
            user_params = %{"balance": user.balance + amount}
            case Account.update_user(user, user_params) do
              {:ok, user} ->
                ConCache.put(:tx_cache, tx_id, %{tx_status: :completed, result: user})
                render(conn, :balance, user: user)
              {:error, %Ecto.Changeset{} = changeset} ->
                  ConCache.put(:tx_cache, tx_id, %{tx_status: :error, result: user})
                  render(conn, :balance, user: user)
            end
          %{tx_status: :pending} ->
            result = retry(tx_id, 3)
            render(conn, :balance, user: result)
          %{result: result} ->
            render(conn, :balance, user: user)
        end
      {:deny, _limit} ->
        render(conn, :error, reason: :limit_reached)
    end
  end

  def transaction_rollback(conn, _params) do
    user_id = get_user(conn)
    user = Account.get_user!(user_id)
    render(conn, :balance, user: user)
  end

  def transaction_bet(%{assigns: assigns} =conn, _params) do
    user_id = get_user(conn)
    case Hammer.check_rate("transaction_bet:#{user_id}", 60_000, 5) do
      {:allow, _count} ->
        user = Account.get_user!(user_id)
        %{params:  params } = assigns
        tx_id = Map.get(params, "transaction_uuid")
        amount = Map.get(params, "amount")
        case ConCache.get(:tx_cache, tx_id) do
          nil ->
            ConCache.put(:tx_cache, tx_id, %{tx_status: :pending, result: nil})
            case user.balance >= amount do
              true ->
                user_params = %{"balance": user.balance - amount}
                case Account.update_user(user, user_params) do
                  {:ok, user} ->
                    ConCache.put(:tx_cache, tx_id, %{tx_status: :completed, result: user})
                    render(conn, :balance, user: user)
                  {:error, %Ecto.Changeset{} = changeset} ->
                      ConCache.put(:tx_cache, tx_id, %{tx_status: :error, result: user})
                      render(conn, :balance, user: user)
                end
              false ->
                render(conn, :balance, user: user)
            end
          %{tx_status: :pending} ->
            result = retry(tx_id, 3)
            render(conn, :balance, user: result)
          %{result: result} ->
            render(conn, :balance, user: user)
        end
      {:deny, _limit} ->
        render(conn, :error, reason: :limit_reached)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = get_user(conn)
    user = Account.get_user!(user_id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

  defp retry(tx_id, 0) do
    ConCache.put(:tx_cache, tx_id, %{tx_status: :error, result: nil})
    nil
  end
  defp retry(tx_id, retries_left) do
    case ConCache.get(:tx_cache, tx_id) do
      %{tx_status: :pending} ->
        :timer.sleep(1000)
        retry(tx_id, retries_left-1)
      %{result: result} ->
        result
    end
  end

  defp get_user(_any) do
    1
  end

end
