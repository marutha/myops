defmodule MyOps.Plugs.Auth do
  import Plug.Conn
  import HmCrypto

  def init(default), do: default

  def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
    case List.keyfind(req_headers, "x-hub88-signature",0) do
      nil ->
        conn
        |> put_status(403)
        |> halt()
      signature ->
        ## Decrypt the signature using public key
        case HmCrypto.valid?() do
          true ->
            conn
          false ->
            conn
            |> put_status(403)
            |> halt()
        end

      end
  end

  def call(conn, default) do
    conn
  end
end
