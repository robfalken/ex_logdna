# Logger backend for LogDNA

A logger backend to send application logs to [LogDNA](https://www.logdna.com) through their ingestion API.

## Installation

The package can be installed by adding `ex_logdna` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_logdna, "~> 0.1.0"}
  ]
end
```

## Configuration

First configure your logger to use the LogDNA backend. It also respects the `level` and `metadata` configuration.

```elixir
config :logger, backends: [LogDNA], level: :info, metadata: [:request_id, :event, :tags]
```

Then configure the backend with some LogDNA specific configurations.

```elixir
config :ex_logdna,
  ingestion_key: System.get_env("LOGDNA_INGESTION_KEY"),
  app: "my-app",
  hostname: "localhost",
  tags: ["web", "prod"]
```
