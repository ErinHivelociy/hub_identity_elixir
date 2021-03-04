use Mix.Config

config :hub_identity_elixir, HubIdentityElixir.TestEndpoint,
  url: [host: "localhost"],
  http: [port: 4002],
  render_errors: [
    view: HubIdentityElixir.Phoenix.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: HubIdentityElixir.PubSub,
  secret_key_base: "nHe507xECwnY7JAjLDIL8jFcgrgUFKCP7xV+bKsf2YETkRylVMMCgBzagg+SRB3Y",
  server: false

config :phoenix, :json_library, Jason

config :hub_identity_elixir, :http, HubIdentityElixir.MockServer
config :hub_identity_elixir, :url, "localhost"
# Print only warnings and errors during test
config :logger, level: :warn
