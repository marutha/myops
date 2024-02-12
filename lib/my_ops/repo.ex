defmodule MyOps.Repo do
  use Ecto.Repo,
    otp_app: :my_ops,
    adapter: Ecto.Adapters.Postgres
end
