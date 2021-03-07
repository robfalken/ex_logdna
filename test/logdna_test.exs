defmodule LogDNATest do
  alias LogDNA.{State}
  use ExUnit.Case
  import Mox

  describe "handle_event/2" do
    setup :verify_on_exit!

    test "post event to ingestion API" do
      Application.put_env(:ex_logdna, :http_client, LogDNA.MockHTTPClient)

      state = %State{level: :info, metadata: [:event], ingestion_key: "abc"}
      group_leader = self()
      timestamp = {{2021, 1, 1}, {11, 59, 59, 999}}

      LogDNA.MockHTTPClient
      |> expect(:request, fn request ->
        assert request == %HTTPoison.Request{
                 body:
                   "{\"lines\":[{\"level\":\"info\",\"line\":\"Message\",\"meta\":{\"event\":\"an event\"},\"timestamp\":1609502399}]}",
                 headers: [
                   {"Content-Type", "application/json; charset=UTF-8"},
                   {"Authorization", "Basic YWJjOg=="}
                 ],
                 method: :post,
                 params: %{},
                 url: "https://logs.logdna.com/logs/ingest"
               }

        {:ok, %HTTPoison.Response{}}
      end)

      assert {:ok, returned_state} =
               LogDNA.handle_event(
                 {:info, group_leader, {Logger, "Message", timestamp, [event: "an event"]}},
                 state
               )

      assert returned_state == state
    end
  end
end
