# HubIdentityElixir

An Elixir Package designed to make implementing HubIdentity authentication easy and fast.
In order to use this package you need to have an account with [HubIdentity](https://stage-identity.hubsynch.com/)

Currently this is only for [Hivelocity](https://www.hivelocity.co.jp/) uses. If you have a
commercial interest please contact the Package Manager Erin Boeger through linkedIn or Github or
through [Hivelocity](https://www.hivelocity.co.jp/contact/).

## Installation

The package can be installed by adding `hub_identity_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hub_identity_elixir, "~> 0.1.0"}
  ]
end
```
## Setup

Setup your configuration in `config.exs, dev.exs, prod.exs` etc:

```elixir
config :hub_identity_elixir, :url, # Either staging, production, or localhost
config :hub_identity_elixir, :public_key, # The public key from HubIdentity
```

Inside your Router add `use HubIdentityElixir.Phoenix.Router` and include
the `hub_identity_routes()`

in `router.exs`:

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use HubIdentityElixir.Phoenix.Router # <- Add HubIdentity Router

  # router stuff..

  scope "/", MyAppWeb do
    pipe_through :browser

    hub_identity_routes()  # <- Add HubIdentity routes
    get "/", PageController, :index
  end
```
This will add the following routes to your application:
- session_path  DELETE  /sessions/logout HubIdentityElixir.Phoenix.SessionController :delete
- session_path  GET     /sessions/new    HubIdentityElixir.Phoenix.SessionController :new
- session_path  GET     /sessions/create HubIdentityElixir.Phoenix.SessionController :create

If you want a `@current_user` helper then add `plug :fetch_current_user` to your pipeline.

## Restricted routes

For authentication required (restricted) routes add the plug `require_authenticated_user`
for example:

```elixir
scope "/", MyAppWeb do
  pipe_through [:browser, :require_authenticated_user]

  get "/something/restricted", PageController, :something
  get "/something_else/restricted", PageController, :something_else
end
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm) at
[hub_identity_elixir](https://hexdocs.pm/hub_identity_elixir)
