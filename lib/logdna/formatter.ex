defmodule LogDNA.Formatter do
  import LogDNA.Config

  def format_event(level, message, datetime, metadata) do
    {tags, metadata} = Keyword.pop(metadata, :tags, [])

    params =
      %{
        tags: merge_tags(tags),
        hostname: logdna_config(:hostname, "")
      }
      |> filter_empty()

    line =
      %{
        app: logdna_config(:app),
        level: level,
        line: message,
        meta: meta(metadata),
        timestamp: timestamp(datetime)
      }
      |> filter_empty()

    body = %{lines: [line]}

    {params, body}
  end

  def timestamp(tuple) do
    {date, {h, m, s, ms}} = tuple

    NaiveDateTime.from_erl!({date, {h, m, s}}, ms)
    |> DateTime.from_naive!(timezone())
    |> DateTime.to_unix()
  end

  def meta([]), do: nil

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

  def filter_empty(map) do
    map
    |> Enum.filter(&present?/1)
    |> Enum.into(%{})
  end

  defp present?({_, ""}), do: false
  defp present?({_, nil}), do: false
  defp present?({_, _}), do: true
end
