defmodule ReceiptItem do
  @moduledoc """
  This is the Hello module.
  """
  defstruct quantity: 0, product: nil, price: %Money{amount: 0}, imported: false, exempted: false

  def new(quantity, product, price),
    do: %__MODULE__{quantity: quantity, product: product, price: price}
end
