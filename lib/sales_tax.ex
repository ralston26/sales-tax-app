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

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts("No arguments given")
  end

  def process(options) do
    # |> ShoppingBasket.print_invoice
    ReceiptParser.init(options)
    |> List.foldl(ShoppingBasket.new(), fn receiptItem, shopping_basket ->
      ShoppingBasket.add_item(shopping_basket, receiptItem)
    end)
    |> ShoppingBasket.generate_invoice()
    |> FileUtils.write_to_file!(options)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [path: :string])
    Path.absname(options[:path])
  end
end
