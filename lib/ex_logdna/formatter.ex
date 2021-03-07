defmodule LogDNA.Formatter do
  import LogDNA.Config

  def format_event(level, message, datetime, metadata) do
    {tags, metadata} = Keyword.pop(metadata, :tags, [])

    tags = merge_tags(tags)

    params = %{
      tags: tags,
      hostname: logdna_config(:hostname, "")
    }

    line = %{
      app: logdna_config(:app),
      level: level,
      line: message,
      meta: meta(metadata),
      timestamp: timestamp(datetime)
    }

    body = %{lines: [line]}

    {params, body}
  end

  def timestamp(tuple) do
    {date, {h, m, s, ms}} = tuple

    NaiveDateTime.from_erl!({date, {h, m, s}}, ms)
    |> DateTime.from_naive!(timezone())
    |> DateTime.to_unix()
  end

  def meta(metadata) do
    metadata
    |> json_encode_event()
    |> Enum.into(%{})
  end

  defp json_encode_event(metadata) do
    case metadata[:event] do
      nil ->
        metadata

      event ->
        Keyword.put(metadata, :event, Jason.encode!(event))
        metadata
    end
  end

  defp merge_tags(nil), do: logdna_config(:tags, []) |> Enum.join(",")

  defp merge_tags(tags) when is_list(tags) do
    merged_tags = tags ++ logdna_config(:tags, [])
    Enum.join(merged_tags, ",")
  end

  defp timezone(), do: logdna_config(:timezone, "Etc/UTC")
end
