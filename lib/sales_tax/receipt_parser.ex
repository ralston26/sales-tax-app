defmodule ReceiptParser do
  @moduledoc """
  Parses the input file and transforms the items to receipt items.
  """

  @exemptions Application.get_env(:sales_tax, :exempted)
  @imported_keyword "imported"

  @doc """
  Reads the file and returns list of receipt items.
  """
  def init(path) do
    path
    |> FileUtils.read_file()
    # drop header
    |> Stream.drop(1)
    |> get_receipt_items()
  end

  def get_receipt_items(input) do
    Enum.map(input, fn item ->
      item
      |> parse_receipt_item()
      |> update_receipt_item()
    end)
  end

  def parse_receipt_item(line_item) do
    [quantity, product, price] =
      line_item
      |> String.split(",")
      |> Enum.map(&String.trim(&1))

  ReceiptItem.new(validate_quantity(quantity), validate_product(product), validate_price(price))
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
    |> String.contains?(@imported_keyword)
  end

  defp exempted?(item_name) do
    item_name
    |> String.downcase()
    |> String.contains?(@exemptions)
  end

  # def validate_quantity(qty) do
  #   case String.to_integer(qty) do
  #     quantity when quantity > 0 -> quantity
  #     {:error, reason} -> raise ArgumentError, message: "#{reason} -> Error"
  #     _ -> raise ArgumentError, message: "#{qty} -> quantity is empty"
  #     end
  # end
  #
  # def validate_price(price) do
  #     if (String.to_float(price) < 0) do
  #       raise ArgumentError, message: "Price cannot be empty or less than ZERO, please check"
  #     else Money.new(String.to_float(price))
  #     end
  # end
  #
  # def validate_product(product) do
  #   if String.trim(product) == "" do
  #     raise ArgumentError, message: "Product value is empty, please check"
  #   else product
  #   end
  # end

  def validate_quantity(qty) do
    case String.to_integer(qty) do
      quantity when quantity > 0 -> quantity
      {:error, reason} -> raise ArgumentError, message: "#{reason} -> not a supported type"
      _ -> raise ArgumentError, message: "quantity #{qty}  must be greater than zero"
      end
  end

  def validate_price(price) do
    case String.to_float(price) do
      price when price >= 0 -> Money.new(price)
      {:error, reason} -> raise ArgumentError, message: "#{reason} -> not a supported type"
      _ -> raise ArgumentError, message: "price #{price}  must be >= 0"
      end
  end

  def validate_product(product) do
    if String.trim(product) == "" do
      raise ArgumentError, message: "Product value is empty, please check"
    else product
    end
  end
end
