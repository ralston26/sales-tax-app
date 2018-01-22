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
                 price: %Money{amount: 1249},
                 product: "book",
                 quantity: 1
               },
               %ReceiptItem{
                 exempted: false,
                 imported: false,
                 price: %Money{amount: 1499},
                 product: "music cd",
                 quantity: 1
               },
               %ReceiptItem{
                 exempted: true,
                 imported: false,
                 price: %Money{amount: 85},
                 product: "chocolate bar",
                 quantity: 1
               }
             ]
  end

  test "passing the file path that does not exit should throw an error" do
    path = Path.join("#{:code.priv_dir(:sales_tax)}", "input.txt")
    assert_raise ArgumentError, fn -> ReceiptParser.init(path) end
  end

  test "passing the line item should return receipt item" do
    assert ReceiptParser.parse_receipt_item("1, imported box of chocolates, 10.00") ==
             %ReceiptItem{
               quantity: 1,
               product: "imported box of chocolates",
               price: %Money{amount: 1000}
             }
  end

  test "sets imported as true and exempted as true" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "imported box of chocolates",
             price: %Money{amount: 1000}
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "imported box of chocolates",
               price: %Money{amount: 1000},
               imported: true,
               exempted: true
             }
  end

  test "sets imported as false and exempted as true" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "box of chocolates",
             price: %Money{amount: 1000}
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "box of chocolates",
               price: %Money{amount: 1000},
               imported: false,
               exempted: true
             }
  end

  test "sets imported as false and exempted as false" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "perfume",
             price: %Money{amount: 1000}
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "perfume",
               price: %Money{amount: 1000},
               imported: false,
               exempted: false
             }
  end

  test "sets imported as true and exempted as false" do
    assert ReceiptParser.update_receipt_item(%ReceiptItem{
             quantity: 1,
             product: "imported perfume",
             price: %Money{amount: 1000}
           }) ==
             %ReceiptItem{
               quantity: 1,
               product: "imported perfume",
               price: %Money{amount: 1000},
               imported: true,
               exempted: false
             }
  end

  test "validate_price , price string is greater than 0" do
    assert ReceiptParser.validate_price("56.89") == %Money{amount: 5689}
  end

  test "validate_price , price string is zero" do
    assert ReceiptParser.validate_price("0.00") == %Money{amount: 0}
  end

  test "validate_price , price string is negative" do
    assert_raise ArgumentError, fn -> ReceiptParser.validate_price("-2.00") end
  end

  test "validate_price , price is empty string" do
    assert_raise ArgumentError, fn -> ReceiptParser.validate_price("") end
  end

  test "validate_quantity , quantity string is greater than 0" do
    assert ReceiptParser.validate_quantity("5") == 5
  end

  test "validate_quantity , quantity string is zero" do
    assert_raise ArgumentError, fn -> ReceiptParser.validate_quantity("0") end
  end

  test "validate_quantity , quantity string is negative" do
    assert_raise ArgumentError, fn -> ReceiptParser.validate_quantity("-2") end
  end

  test "validate_quantity , quantity is empty string" do
    assert_raise ArgumentError, fn -> ReceiptParser.validate_quantity("") end
  end
end
