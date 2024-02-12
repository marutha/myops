defmodule MyOps.Plugs.RequestId do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{params: params} = conn, _default) do
    request_uuid = Map.get(params, "request_uuid")
    params = Map.delete(params, "request_uuid")

    conn
    |> assign(:request_uuid, request_uuid)
    |> assign(:params, params)
  end

  def call(conn, default) do
    conn
  end
end
