defmodule TaxCalculator do
  @moduledoc """
  Documentation for SalesTax.
  """
  @basic_tax_rate 10
  @imported_tax_rate 5

  # determines the tax rate of an item
  def get_tax_rate(imported, exempted) do
    case {exempted, imported} do
      {true, true} -> @imported_tax_rate
      {false, true} -> @imported_tax_rate + @basic_tax_rate
      {false, false} -> @basic_tax_rate
      _ -> 0
    end
  end

  def compute_item_tax(%ReceiptItem{} = receipt_item) do
    tax_rate = get_tax_rate(receipt_item.imported, receipt_item.exempted)
    item_tax = receipt_item.quantity * receipt_item.price * tax_rate / 100
    Float.ceil(item_tax * 20) / 20
  end
end
