defmodule SalesTax do
  @moduledoc """
  Documentation for SalesTax.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SalesTax.hello
      :world

  """
  # @path_env %{dev: ["lib/priv", "input2.txt"]}
  # @path Path.join(@path_env[Mix.env])

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts("No arguments given")
  end

  def process(options) do
    ReceiptParser.init(options)
    |> List.foldl(ShoppingBasket.new, fn receiptItem, shopping_basket
    -> ShoppingBasket.add_item(shopping_basket, receiptItem) end)
    |> ShoppingBasket.generate_invoice
    #|> ShoppingBasket.print_invoice
    |> FileReader.write_to_file!(options)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [name: :string])
    Path.absname(options[:name])
  end
end
