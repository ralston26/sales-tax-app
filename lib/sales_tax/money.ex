defmodule Money do
  @moduledoc """
  Custom sturct to hold amount as integer instead of handling directly with float .
  """
  defstruct amount: 0

  @type t :: %__MODULE__{
          amount: integer
        }

  def new(float) when is_float(float) do
    %Money{amount: round(float * 100)}
  end

  def new(int) when is_integer(int) do
    %Money{amount: int}
  end

  def new_from_cents(amount) do
    Money.new(amount / 100)
  end

  def add(%Money{amount: a}, %Money{amount: b}) do
    Money.new(a + b)
  end

  def multiply(%Money{amount: amount}, multiplier) when is_integer(multiplier) do
    Money.new(amount * multiplier)
  end

  def multiply(%Money{amount: amount}, multiplier) when is_float(multiplier) do
    Money.new(round(amount * multiplier))
  end

  def to_string(%Money{amount: amount}) do
    :erlang.float_to_binary(amount / 100, decimals: 2)
  end

  def cash_rounding(%Money{amount: amount}) do
    Money.new_from_cents(Float.ceil(amount / 5) * 5)
  end
end
