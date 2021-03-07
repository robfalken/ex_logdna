defmodule LogDNA.Config do
  @spec logger_config(atom(), any()) :: any()
  def logger_config(key, default \\ nil), do: Application.get_env(:logger, key, default)

  @spec logdna_config(atom(), any()) :: any()
  def logdna_config(key, default \\ nil),
    do: Application.get_env(:ex_logdna, key, default)
end
