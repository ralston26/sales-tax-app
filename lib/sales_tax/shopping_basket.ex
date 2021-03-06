defmodule ShoppingBasket do
  @moduledoc """
  Documentation for SalesTax.
  """
  defstruct total: %Money{amount: 0}, sales_tax: %Money{amount: 0}, items: []

  def new, do: %__MODULE__{}

  @doc """
  Transforms receipt item to basket item and adds to shopping basket, computing
  total and sales tax upon add of each item.
  """
  def add_item(%__MODULE__{} = shopping_basket, %ReceiptItem{} = receipt_item) do
    basket_item = BasketItem.new(receipt_item)

    %{
      shopping_basket
      | total: Money.add(shopping_basket.total, basket_item.price),
        sales_tax: Money.add(shopping_basket.sales_tax, basket_item.item_tax),
        items: shopping_basket.items ++ [basket_item]
    }
  end

  @doc """
  Transforms shopping basket item to string for display and writing invoice to file.
  """
  def generate_invoice(%ShoppingBasket{items: items, sales_tax: sales_tax, total: total}) do
    invoice =
      Enum.reduce(items, "", fn %BasketItem{quantity: quantity, product: product, price: price},
                                acc ->
        acc <> join(Integer.to_string(quantity), product, Money.to_string(price))
      end)

    invoice <>
      "\nSales Taxes: " <>
      Money.to_string(sales_tax) <> "\n" <> "Total: " <> Money.to_string(total) <> "\n"
  end

  defp join(quantity, product, price) do
    quantity <> ", " <> product <> ", " <> price <> "\n"
  end
end
