defmodule ReceiptParserTest do
  use ExUnit.Case
  doctest ReceiptParser

  test "passing the file path should a return list of receipt items" do
    path = Path.join("#{:code.priv_dir(:sales_tax)}", "input1.txt")

    assert ReceiptParser.init(path) ==
             [
               %ReceiptItem{
                 exempted: true,
                 imported: false,
                 price: 12.49,
                 product: "book",
                 quantity: 1
               },
               %ReceiptItem{
                 exempted: false,
                 imported: false,
                 price: 14.99,
                 product: "music cd",
                 quantity: 1
               },
               %ReceiptItem{
                 exempted: true,
                 imported: false,
                 price: 0.85,
                 product: "chocolate bar",
                 quantity: 1
               }
             ]
  end

  test "passing the file path that does not exit should throw an error" do
    path = Path.join("#{:code.priv_dir(:sales_tax)}", "input.txt")
    catch_error(ReceiptParser.init(path))
  end

  test "passing the line item should return receipt item" do
    assert ReceiptParser.parse_receipt_item("1, imported box of chocolates, 10.00") ==
             %ReceiptItem{quantity: 1, product: "imported box of chocolates", price: 10.00}
  end

  test "sets imported as true and exempted as true" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "imported box of chocolates",
             price: 10.00
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "imported box of chocolates",
               price: 10.00,
               imported: true,
               exempted: true
             }
  end

  test "sets imported as false and exempted as true" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "box of chocolates",
             price: 10.00
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "box of chocolates",
               price: 10.00,
               imported: false,
               exempted: true
             }
  end

  test "sets imported as false and exempted as false" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "perfume",
             price: 10.00
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "perfume",
               price: 10.00,
               imported: false,
               exempted: false
             }
  end

  test "sets imported as true and exempted as false" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "imported perfume",
             price: 10.00
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "imported perfume",
               price: 10.00,
               imported: true,
               exempted: false
             }
  end
end
