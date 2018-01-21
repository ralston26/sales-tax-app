defmodule ShoppingBasket do
  @moduledoc """
  Documentation for SalesTax.
  """
  defstruct total: 0, sales_tax: 0, items: []

  def new, do: %__MODULE__{}

  def add_item(%__MODULE__{} = shopping_basket, receipt_item) do
    basket_item = BasketItem.new(receipt_item)

    %{
      shopping_basket
      | total: shopping_basket.total + basket_item.price,
        sales_tax: shopping_basket.sales_tax + basket_item.item_tax,
        items: shopping_basket.items ++ [basket_item]
    }
  end

  def generate_invoice(%ShoppingBasket{} = shopping_basket) do
    invoice = Enum.reduce(shopping_basket.items, "", fn(item,acc)->
      acc <> Integer.to_string(item.quantity)<>", "
      <>item.product<>", "
      <>Float.to_string(item.price)<>"\n" end)

      invoice <>"\nSales Taxes: "<>Float.to_string(shopping_basket.sales_tax)<>"\n"
            <>"Total: "<>Float.to_string(shopping_basket.total)<>"\n"
  end

  def print_invoice(content) do
    IO.puts(content)
  end
end
