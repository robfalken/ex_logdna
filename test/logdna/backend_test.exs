defmodule LogDNA.BackendTest do
  alias LogDNA.Backend
  use ExUnit.Case

  describe "handle_event/2" do
    test "it works" do
      state = %Backend{level: :info, metadata: [:event]}
      group_leader = self()
      timestamp = {{2021, 1, 1}, {11, 59, 59, 999}}

      Backend.handle_event(
        {:info, group_leader, {Logger, "Message", timestamp, [event: "an event"]}},
        state
      )
    end
  end
end
