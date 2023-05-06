# frozen_string_literal: true
require "test_helper"

class Measured::UnitConversionTest < ActiveSupport::TestCase
  setup do
    @unit_conversion = Measured::UnitConversion.new("10 Cake")
  end

  test "#initialize parses out the unit and the number part" do
    assert_equal 10, @unit_conversion.amount
    assert_equal "Cake", @unit_conversion.unit

    unit_conversion = Measured::UnitConversion.new(["5.5", "sweets"])
    assert_equal BigDecimal("5.5"), unit_conversion.amount
    assert_equal "sweets", unit_conversion.unit

    unit_conversion = Measured::UnitConversion.new("1/3 bitter pie")
    assert_equal Rational(1, 3), unit_conversion.amount
    assert_equal "bitter pie", unit_conversion.unit
  end

  test "#initialize raises if the format of the value is incorrect" do
    assert_raises Measured::UnitError do
      Measured::UnitConversion.new("hello")
    end

    assert_raises Measured::UnitError do
      Measured::UnitConversion.new("123456")
    end
  end

  test "#to_s returns an expected string" do
    assert_nil Measured::UnitConversion.new(nil).to_s
    assert_equal "1/2 sweet", Measured::UnitConversion.new("0.5 sweet").to_s
  end

  test "#inverse_amount returns 1/amount" do
    assert_equal Rational(1, 10), @unit_conversion.inverse_amount
  end

  test "#inverse_amount handles nil for base unit" do
    assert_nil Measured::UnitConversion.new(nil).inverse_amount
  end
end
