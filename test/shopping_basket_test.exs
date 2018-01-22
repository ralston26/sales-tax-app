defmodule ShoppingBasketTest do
  use ExUnit.Case
  doctest ShoppingBasket

  test "add new receipt item to empty shopping basket
  will create basket item, generate total and sales tax" do
    assert ShoppingBasket.add_item(ShoppingBasket.new(), %ReceiptItem{
             exempted: true,
             imported: false,
             price: %Money{amount: 1249},
             product: "book",
             quantity: 1
           }) == %ShoppingBasket{
             items: [
               %BasketItem{
                 item_tax: %Money{amount: 0},
                 price: %Money{amount: 1249},
                 product: "book",
                 quantity: 1
               }
             ],
             total: %Money{amount: 1249},
             sales_tax: %Money{amount: 0}
           }
  end

  test "add new receipt item to shopping basket with 1 basket item
  will create basket item, generate total and sales tax" do
    assert ShoppingBasket.add_item(
             %ShoppingBasket{
               items: [
                 %BasketItem{
                   item_tax: %Money{amount: 0},
                   price: %Money{amount: 1249},
                   product: "book",
                   quantity: 1
                 }
               ],
               total: %Money{amount: 1249},
               sales_tax: %Money{amount: 0}
             },
             %ReceiptItem{
               exempted: true,
               imported: true,
               price: %Money{amount: 1499},
               product: "music cd",
               quantity: 1
             }
           ) == %ShoppingBasket{
             items: [
               %BasketItem{
                 item_tax: %Money{amount: 0},
                 price: %Money{amount: 1249},
                 product: "book",
                 quantity: 1
               },
               %BasketItem{
                 item_tax: %Money{amount: 75},
                 price: %Money{amount: 1574},
                 product: "music cd",
                 quantity: 1
               }
             ],
             total: %Money{amount: 2823},
             sales_tax: %Money{amount: 75}
           }
  end
end
