defmodule ReceiptParser do
  @moduledoc """
  Documentation for SalesTax.
  """

  # TODO  dynamic path

  @exemptions Application.get_env(:sales_tax, :exempted)

  def init(path) do
    path
    |> FileReader.read_file!
    |> get_receipt_items
  end

  def get_receipt_items(input) do
    Enum.map(input, fn item ->
      item
      |> parse_receipt_item
      |> update_receipt_item
    end)
  end

  def parse_receipt_item(line_item) do
    [quantity, product, price] =
      line_item
      |> String.split(",")
      |> Enum.map(&String.trim(&1))

    quantity = String.to_integer(quantity)
    price = String.to_float(price)
    ReceiptItem.new(quantity, product, price)
  end

  def update_receipt_item(receipt_item) do
    # Note in real time these two fields are the details obtained from
    # product catalogue API or db, for simplicity lets determine the category
    # and imported fields based on the item name in the receipt line item
    %ReceiptItem{
      receipt_item
      | imported: is_imported?(receipt_item.product),
        exempted: is_exempted?(receipt_item.product)
    }
  end

  defp is_imported?(item_name) do
    String.contains?(item_name, "imported")
  end

  defp is_exempted?(item_name) do
    String.contains?(item_name, @exemptions)
  end
end
