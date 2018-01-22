defmodule ReceiptItem do
  @moduledoc """
  Struct to hold the receipt items with additional params to compute tax.
  """
  defstruct quantity: 0, product: nil, price: nil, imported: false, exempted: false

  @type t :: %__MODULE__{
          quantity: integer,
          product: String.t(),
          price: Money.t(),
          imported: boolean,
          exempted: boolean
        }

  def new(quantity, product, price),
    do: %__MODULE__{quantity: quantity, product: product, price: price}
end
