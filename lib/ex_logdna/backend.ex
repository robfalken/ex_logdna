defmodule LogDNA.Backend do
  @behaviour :gen_event
  import LogDNA.Config
  alias LogDNA.{Formatter, Ingestion, State}

  def init(__MODULE__) do
    case initial_state() do
      %State{ingestion_key: nil} ->
        {:error, "No LogDNA ingestion key configured"}

      state ->
        HTTPoison.start()
        {:ok, state}
    end
  end

  # We're not buffering anything, so this is a no-op
  def handle_event(:flush, state), do: {:ok, state}

  # It is recommended that handlers ignore messages
  # where the group leader is in a different node
  # than the one where the handler is installed
  def handle_event({_, gl, {_, _, _, _}}, state) when node(gl) != node(), do: {:ok, state}

  def handle_event(
        {level, _group_leader, {Logger, msg, timestamp, metadata}},
        state
      ) do
    if Logger.compare_levels(state.level, level) != :gt do
      metadata = whitelist_metadata(metadata, state)
      message = message(msg)

      Formatter.format_event(level, message, timestamp, metadata)
      |> Ingestion.prepare_request(state)
      |> Ingestion.post_request()
    end

    {:ok, state}
  end

  @spec message(any()) :: String.t()
  defp message(msg) when is_binary(msg), do: msg
  defp message(msg) when is_list(msg), do: to_string(msg)
  defp message(msg), do: inspect(msg)

  def handle_call(_request, state) do
    # TODO: Handle config calls
    {:ok, :ok, state}
  end

  defp initial_state() do
    %State{
      ingestion_key: logdna_config(:ingestion_key),
      metadata: logger_config(:metadata, [])
    }
  end

  defp whitelist_metadata(metadata, state), do: Keyword.take(metadata, state.metadata)
end
