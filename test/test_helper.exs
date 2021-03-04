children = [
  {Phoenix.PubSub, name: HubIdentityElixir.PubSub},
  HubIdentityElixir.TestEndpoint
]

opts = [strategy: :one_for_one, name: HubIdentityElixir.Supervisor]
Supervisor.start_link(children, opts)

ExUnit.start()
