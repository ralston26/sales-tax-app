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
end
