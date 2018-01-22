defmodule TaxCalculator do
  @moduledoc """
  Handles tax relates computations.
  """
  @basic_tax_rate Application.get_env(:sales_tax, :basic_tax_rate)
  @imported_tax_rate Application.get_env(:sales_tax, :imported_tax_rate)

  @doc """
  Calculates the total tax rate for the receipt item.
  """
  def get_tax_rate(imported, exempted) do
    case {exempted, imported} do
      {true, true} -> @imported_tax_rate
      {false, true} -> @imported_tax_rate + @basic_tax_rate
      {false, false} -> @basic_tax_rate
      _ -> 0
    end
  end

  @doc """
  Calculates the total tax amount per receipt item.
  """
  def compute_item_tax(%ReceiptItem{} = receipt_item) do
    tax_rate = get_tax_rate(receipt_item.imported, receipt_item.exempted)

    Money.multiply(receipt_item.price, receipt_item.quantity)
    |> Money.multiply(tax_rate / 100)
    |> Money.cash_rounding()
  end
end
