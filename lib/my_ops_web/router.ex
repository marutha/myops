defmodule MyOpsWeb.Router do
  use MyOpsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyOpsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug MyOps.Plugs.RequestId, "en"
  end

  # scope "/", MyOpsWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  #   resources "/users", UserController

  # end

  # Other scopes may use custom stacks.
  scope "/", MyOpsWeb do
    pipe_through :api

    post "/user/info", UserController, :user_info
    post "/user/authorize", UserController, :authorize
    post "/user/balance", UserController, :balance
    post "/transaction/win", UserController, :transaction_win
    post "/transaction/bet", UserController, :transaction_bet
    post "/transaction/rollback", UserController, :transaction_rollback
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_ops, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyOpsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
