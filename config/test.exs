use Mix.Config

config :phoenix, :json_library, Jason

config :hub_identity_elixir, :http, HubIdentityElixir.MockServer
config :hub_identity_elixir, :url, "localhost"
