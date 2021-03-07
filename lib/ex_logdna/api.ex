defmodule LogDNA.HTTPClient do
  @callback request(%HTTPoison.Request{}) :: {:ok, %HTTPoison.Response{}} | {:error, any()}
end
