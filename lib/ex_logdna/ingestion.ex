defmodule LogDNA.Ingestion do
  import LogDNA.Config
  @ingestion_url "https://logs.logdna.com/logs/ingest"

  def prepare_request({params, body}) do
    credentials = logdna_config(:ingestion_key, "") |> Base.encode64()

    %HTTPoison.Request{
      method: :post,
      url: @ingestion_url,
      body: Jason.encode!(body),
      params: params,
      headers: [
        {"Content-Type", "application/json; charset=UTF-8"},
        {"Authorization", "Basic #{credentials}"}
      ],
      options: [hackney: [:insecure]]
    }
  end

  def post_request(request) do
    request
    |> HTTPoison.request()
  end
end
