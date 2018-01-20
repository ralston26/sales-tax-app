defmodule BasketItem do
  @moduledoc """
  Documentation for SalesTax.
  """
  import TaxCalculator, only: [compute_item_tax: 1]

  defstruct quantity: 0, product: "", price: 0, item_tax: 0

  def new(receipt_item) do
    item_tax = compute_item_tax(receipt_item)

    %__MODULE__{
      quantity: receipt_item.quantity,
      product: receipt_item.product,
      price: Float.round(receipt_item.quantity * receipt_item.price + item_tax, 2),
      item_tax: item_tax
    }
  end
end
