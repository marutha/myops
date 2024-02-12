defmodule MyOpsWeb.UserTokenJSON do
  alias MyOps.Account.UserToken

  @doc """
  Renders a list of user_tokens.
  """
  def index(%{user_tokens: user_tokens}) do
    %{data: for(user_token <- user_tokens, do: data(user_token))}
  end

  @doc """
  Renders a single user_token.
  """
  def show(%{user_token: user_token}) do
    %{data: data(user_token)}
  end

  defp data(%UserToken{} = user_token) do
    %{
      id: user_token.id,
      token: user_token.token,
      ttl: user_token.ttl,
      game_code: user_token.game_code
    }
  end
end
