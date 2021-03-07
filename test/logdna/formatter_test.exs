defmodule LogDNA.FormatterTest do
  alias LogDNA.Formatter
  use ExUnit.Case

  describe "format_event/4" do
    @datetime {{2021, 1, 1}, {11, 59, 59, 999}}

    setup do
      Application.put_env(:ex_logdna, :app, "TestApp")
      Application.put_env(:ex_logdna, :tags, ["test", "log"])
      Application.put_env(:ex_logdna, :hostname, "localhost")
    end

    test "formats body to LogDNA structure" do
      {_, body} = Formatter.format_event(:info, "Message.", @datetime, prop: "value")

      [line | _] = body[:lines]

      assert line[:app] == "TestApp"
      assert line[:level] == :info
      assert line[:line] == "Message."
      assert line[:meta] == %{prop: "value"}
      assert line[:timestamp] == 1_609_502_399
    end

    test "formats params to LogDNA structure" do
      {params, _} = Formatter.format_event(:info, "Message.", @datetime, prop: "value")

      assert params[:tags] == "test,log"
      assert params[:hostname] == "localhost"
    end

    test "JSON encodes 'event'" do
      {_, body} = Formatter.format_event(:info, "Message.", @datetime, event: %{json: true})

      [line | _] = body[:lines]

      assert line[:meta][:event] == %{json: true}
    end

    test "merges tags" do
      {params, _} =
        Formatter.format_event(:info, "Message.", @datetime, tags: ~w[additional extra])

      assert params[:tags] == "additional,extra,test,log"
    end
  end
end
