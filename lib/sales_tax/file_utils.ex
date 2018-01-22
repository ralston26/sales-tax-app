defmodule FileUtils do
  @moduledoc """
  File utils to handle read and write.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SalesTax.hello
      :world

  """
  @output_suffix "_output"

  def read_file!(path) do
    # discard header
    path
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp get_output_path(path) do
    Path.absname(Path.rootname(path) <> @output_suffix <> Path.extname(path))
  end

  def write_to_file!(content, path) do
    path
    |> get_output_path
    |> File.write!(content)

    IO.puts(content)
  end
end
