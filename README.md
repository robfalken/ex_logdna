![CircleCI status badge](https://circleci.com/gh/robertfalken/ex_logdna.svg?style=shield&circle-token=fbc07c0c1283759331039b12a186caeab0d97518)

# Elixir logger backend for LogDNA

A logger backend for elixir to send application logs to [LogDNA](https://www.logdna.com) through their ingestion API.

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

Find more information in the [LogDNA ingestion API documentation](https://docs.logdna.com/reference#logsingest).

## Usage

After configuring your application to use the `LogDNA` backend, just use logger as you normally would. To send a log entry with log level `info` for instance:

```elixir
Logger.info("Logging stuff to LogDNA")
```

The backend has support for metadata, just pass it on as the second argument:

```elixir
Logger.info("Logging stuff to LogDNA with additional metadata.", user_id: "some-user-id")
```

### 🪄 Magic metadata

Some metadata properties are reserved for magic.

#### Tags

If you pass in `tags` with your log entry, it won't be sent in as metadata, but as native LogDNA tags.

```elixir
Logger.info("Logging stuff to LogDNA with additional metadata.", tags: ["one", "two"])
```

Should you have configured global tags in your config file, these event tags will be merged into the global tags, and they are all passed along to the ingestion API.
