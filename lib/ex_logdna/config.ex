defmodule LogDNA.Config do
  def logger_config(key, default \\ nil), do: Application.get_env(:logger, key, default)

  def logdna_config(key, default \\ nil),
    do: Application.get_env(:ex_logdna, key, default)
end
