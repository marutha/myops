defmodule MyOps.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyOpsWeb.Telemetry,
      MyOps.Repo,
      {DNSCluster, query: Application.get_env(:my_ops, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyOps.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyOps.Finch},
      {ConCache, [name: :tx_cache, ttl_check_interval: false]},
      # Start a worker by calling: MyOps.Worker.start_link(arg)
      # {MyOps.Worker, arg},
      # Start to serve requests, typically the last entry
      MyOpsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyOps.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyOpsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
