defmodule LogDNA.Ingestion do
  import LogDNA.Config
  alias LogDNA.State
  @ingestion_url "https://logs.logdna.com/logs/ingest"

  @spec prepare_request({map(), map()}, %State{}) :: %HTTPoison.Request{}
  def prepare_request({params, body}, state) do
    credentials = (state.ingestion_key <> ":") |> Base.encode64()

    %HTTPoison.Request{
      method: :post,
      url: @ingestion_url,
      body: Jason.encode!(body),
      params: params,
      headers: [
        {"Content-Type", "application/json; charset=UTF-8"},
        {"Authorization", "Basic #{credentials}"}
      ]
    }
  end

  @spec post_request(%HTTPoison.Request{}) :: {:ok, %HTTPoison.Response{}} | {:error, any()}
  def post_request(request) do
    request
    |> client().request()
  end

  @spec client() :: LogDNA.HTTPClient
  defp client() do
    logdna_config(:http_client, HTTPoison)
  end
end
