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

    Money.multiply(receipt_item.price, receipt_item.quantity)
    |> Money.multiply(tax_rate / 100)
    |> Money.cash_rounding()
  end
end
