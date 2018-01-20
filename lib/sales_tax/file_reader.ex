defmodule FileReader do
  @moduledoc """
  Documentation for SalesTax.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SalesTax.hello
      :world

  """
  def read_file!(path) do
    # discard header
    path
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end
end
