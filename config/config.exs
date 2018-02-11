# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :auth,
  ecto_repos: [Auth.Repo]

# Configures the endpoint
config :auth, AuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hLWDMAmLSnWQe5QxBdIvXmHgLSw87suQuvMqkmRet++wtyYE+t20zJhpBclKOub/",
  render_errors: [view: AuthWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Auth.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :auth, Auth.Guardian,
  issuer: "Auth",
  secret_key: "use mix phx.gen.secret"

config :ueberauth, Ueberauth,
  base_path: "/api/auth",
  providers: [
    identity: {Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      callback_path: "/api/auth/identity/callback",
      nickname_field: :username,
      param_nesting: "user",
      uid_field: :username
    ]}
  ]

# Configure the authentication plug pipeline
config :auth, Auth.Plugs.AuthAccessPipeline,
  module: Auth.Guardian,
  error_handler: Auth.Plug.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
