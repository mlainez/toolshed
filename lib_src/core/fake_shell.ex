defmodule Toolshed.Core.FakeShell do
  @moduledoc """
  Provides a small interactive fake shell used in tests and local development.

  The shell reads lines from `IO.gets/1` and delegates command execution
  to `Toolshed.cmd/1`. It is intended for manual use or lightweight
  integration testing where an interactive prompt is convenient.

    Example

      iex> Toolshed.fake_shell()
      Starting fake shell. Type 'exit' to quit.
      fksh> echo hello
      ...

  The function returns `:ok` when the user types `exit`.
  """

  @prompt "fksh> "

  @doc """
  Start an interactive fake shell session.

  The function prints a short banner then enters a read-execute loop.
  Each non-empty line is passed to `Toolshed.cmd/1`. Type `"exit"` to end the session. The function returns `:ok` on exit.
  """
  @spec fake_shell() :: :ok
  def fake_shell() do
    IO.puts("Starting fake shell. Type 'exit' to quit.")
    loop()
  end

  defp loop do
    case IO.gets(@prompt) do
      nil ->
        :ok

      "exit\n" ->
        :ok

      line ->
        line
        |> String.trim()
        |> exec()

        loop()
    end
  end

  defp exec(""), do: :ok

  defp exec(cmdline) do
    try do
      Toolshed.cmd(cmdline)
    rescue
      e ->
        IO.puts("error: #{inspect(e)}")
    end
  end
end
