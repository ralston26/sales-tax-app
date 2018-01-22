defmodule FileUtils do
  @moduledoc """
  File utils to handle write.
  """
  @output_suffix "_output"

  @doc """
  Validates file throws error when file is not found or file size is empty.
  """
  def validate_file(path) do
    case File.stat(path) do
      {:ok, %{size: size}} when size > 0 -> path
      {:error, _} -> raise ArgumentError, message: "#{path} -> file not found"
      {_, _} -> raise ArgumentError, message: "#{path} -> file is empty"
    end
  end

  @doc """
  Validates file and returns the stream.
  """
  def read_file(path) do
    path
    |> validate_file()
    |> File.stream!()
  end

  defp get_output_path(path) do
    Path.absname(Path.rootname(path) <> @output_suffix <> Path.extname(path))
  end

  @doc """
  Writes to a file with _output appended at the filename and prints on console.
  """
  def write_to_file!(content, path) do
    path
    |> get_output_path
    |> File.write!(content)

    IO.puts(content)
  end
end
