defmodule ReceiptParser do
  @moduledoc """
  Parses the input file and transforms the items to receipt items.
  """

  @exemptions Application.get_env(:sales_tax, :exempted)

  def init(path) do
    path
    |> FileUtils.read_file!()
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
    price = Money.new(String.to_float(price))
    ReceiptItem.new(quantity, product, price)
  end

  def update_receipt_item(receipt_item) do
    # HACK
    # Note: In real time scenario these two fields are the details obtained from
    # the product catalogue API or DB, for simplicity lets determine the category
    # and imported fields based on the item name in the receipt line item
    %ReceiptItem{
      receipt_item
      | imported: imported?(receipt_item.product),
        exempted: exempted?(receipt_item.product)
    }
  end

  defp imported?(item_name) do
    item_name
    |> String.downcase()
    |> String.contains?("imported")
  end

  defp exempted?(item_name) do
    item_name
    |> String.downcase()
    |> String.contains?(@exemptions)
  end
end
