defmodule TaxCalculatorTest do
  use ExUnit.Case
  doctest TaxCalculator

  test "get tax_rate for tax exempted item" do
    # imported = false , exempted = true
    assert TaxCalculator.get_tax_rate(false, true) == 0
  end

  test "get tax_rate for tax exempted item and imported" do
    # imported = true , exempted = true
    assert TaxCalculator.get_tax_rate(true, true) == 5
  end

  test "get tax_rate for taxed item and imported" do
    # imported = true , exempted = false
    assert TaxCalculator.get_tax_rate(true, false) == 15
  end

  test "get tax_rate for non imported taxed item" do
    # imported = false , exempted = true
    assert TaxCalculator.get_tax_rate(false, false) == 10
  end

  test "get computed item tax for tax exempted item" do
    assert TaxCalculator.compute_item_tax(%ReceiptItem{
             exempted: true,
             imported: false,
             price: %Money{amount: 1249},
             product: "book",
             quantity: 1
           }) == %Money{amount: 0}
  end

  test "get computed item tax for tax exempted item and imported" do
    assert TaxCalculator.compute_item_tax(%ReceiptItem{
             exempted: true,
             imported: true,
             price: %Money{amount: 1249},
             product: "imported book",
             quantity: 1
           }) == %Money{amount: 65}
  end

  test "get computed item tax for taxed item and imported" do
    assert TaxCalculator.compute_item_tax(%ReceiptItem{
             exempted: false,
             imported: true,
             price: %Money{amount: 2799},
             product: "imported bottle of perfume",
             quantity: 1
           }) == %Money{amount: 420}
  end

  test "get computed item tax for non imported taxed item" do
    assert TaxCalculator.compute_item_tax(%ReceiptItem{
             exempted: false,
             imported: false,
             price: %Money{amount: 1899},
             product: "imported bottle of perfume",
             quantity: 1
           }) == %Money{amount: 190}
  end
end
