defmodule BasketItem do
  @moduledoc """
  Struct to hold receipt item with updated price and item tax .
  """
  import TaxCalculator, only: [compute_item_tax: 1]

  defstruct quantity: 0, product: nil, price: nil, item_tax: nil

  @type t :: %__MODULE__{
          quantity: integer,
          product: String.t(),
          price: Money.t(),
          item_tax: Money.t()
        }

  def new(%ReceiptItem{} = receipt_item) do
    item_tax = compute_item_tax(receipt_item)

    %__MODULE__{
      quantity: receipt_item.quantity,
      product: receipt_item.product,
      price:
        Money.multiply(receipt_item.price, receipt_item.quantity)
        |> Money.add(item_tax),
      item_tax: item_tax
    }
  end
end
