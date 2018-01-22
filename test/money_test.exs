defmodule MoneyTest do
  use ExUnit.Case
  doctest Money

  test "create money passing integer" do
    assert Money.new(10) == %Money{amount: 10}
  end

  test "create money passing float" do
    assert Money.new(10.578990) == %Money{amount: 1058}
  end

  test "add money" do
    assert Money.add(%Money{amount: 1050}, %Money{amount: 14}) == %Money{amount: 1064}
  end

  test "multiply money by integer" do
    assert Money.multiply(%Money{amount: 1050}, 10) == %Money{amount: 10500}
  end

  test "multiply money by float" do
    assert Money.multiply(%Money{amount: 1050}, 10.889) == %Money{amount: 11433}
  end

  test "money from cents" do
    assert Money.new_from_cents(124) == %Money{amount: 124}
  end

  test "cash rounding" do
    assert Money.cash_rounding(%Money{amount: 105_678}) == %Money{amount: 105_680}
  end

  test "to string" do
    assert Money.to_string(%Money{amount: 105_678}) == "1056.78"
  end
end
