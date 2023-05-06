# frozen_string_literal: true
require "test_helper"

class Measured::DynamicArithmeticTest < ActiveSupport::TestCase
  setup do
    @two = DynamicMagic.new(2, :magic_missile)
    @three = DynamicMagic.new(3, :magic_missile)
    @four = DynamicMagic.new(4, :magic_missile)
  end

  test "should be able to sum same units" do
    assert_equal DynamicMagic.new(9, :magic_missile), [@two, @three, @four].sum
  end

  test 'can check for finite?' do
    assert DynamicMagic.new(0, :magic_missile).finite?
    refute DynamicMagic.new(Float::INFINITY, :magic_missile).finite?
  end

  test 'can check for infinite?' do
    assert DynamicMagic.new(Float::INFINITY, :magic_missile).infinite?
    refute DynamicMagic.new(0, :magic_missile).infinite?
  end

  test 'can check for zero?' do
    assert DynamicMagic.new(0, :magic_missile).zero?
    refute DynamicMagic.new(1, :magic_missile).zero?
  end

  test 'can check for nonzero?' do
    assert_equal DynamicMagic.new(10, :magic_missile), DynamicMagic.new(10, :magic_missile).nonzero?
    assert DynamicMagic.new(10, :magic_missile).nonzero?
    refute DynamicMagic.new(0, :magic_missile).nonzero?
  end

  test 'can check for positive?' do
    assert DynamicMagic.new(1, :magic_missile).positive?
    refute DynamicMagic.new(-1, :magic_missile).positive?
  end

  test 'can check for negative?' do
    assert DynamicMagic.new(-1, :magic_missile).negative?
    refute DynamicMagic.new(1, :magic_missile).negative?
  end

  test "#+ should add together same units" do
    assert_equal DynamicMagic.new(5, :magic_missile), @two + @three
    assert_equal DynamicMagic.new(5, :magic_missile), @three + @two
  end

  test "#+ shouldn't add with a Integer" do
    assert_raises(TypeError) { @two + 3 }
    assert_raises(TypeError) { 2 + @three }
  end

  test "#+ should raise if different unit system" do
    assert_raises TypeError do
      OtherFakeSystem.new(1, :other_fake_base) + @two
    end

    assert_raises TypeError do
      @two + OtherFakeSystem.new(1, :other_fake_base)
    end
  end

  test "#+ should raise if adding something nonsense" do
    assert_raises TypeError do
      @two + "thing"
    end

    assert_raises TypeError do
      "thing" + @two
    end
  end

  test "#- should subtract same units" do
    assert_equal DynamicMagic.new(-1, :magic_missile), @two - @three
    assert_equal DynamicMagic.new(1, :magic_missile), @three - @two
  end

  test "#- shouldn't subtract with a Integer" do
    assert_raises(TypeError) { @two - 3 }
    assert_raises(TypeError) { 2 - @three }
  end

  test "#- should raise if different unit system" do
    assert_raises TypeError do
      OtherFakeSystem.new(1, :other_fake_base) - @two
    end

    assert_raises TypeError do
      @two - OtherFakeSystem.new(1, :other_fake_base)
    end
  end

  test "#- should raise if subtracting something nonsense" do
    assert_raises TypeError do
      @two - "thing"
    end

    assert_raises NoMethodError do
      "thing" - @two
    end
  end

  test "#-@ returns the negative version" do
    assert_equal DynamicMagic.new(-2, :magic_missile), -@two
  end

  test "dynamic length conversion" do
    m = DynamicLength.new(1, :m)
    dm = DynamicLength.new(1, :dm)
    cm = DynamicLength.new(1, :cm)
    mm = DynamicLength.new(1, :mm)

    assert_equal DynamicLength.new(1, :m), m.convert_to(:m)
    assert_equal DynamicLength.new(10, :dm), m.convert_to(:dm)
    assert_equal DynamicLength.new(100, :cm), m.convert_to(:cm)
    assert_equal DynamicLength.new(1000, :mm), m.convert_to(:mm)

    assert_equal DynamicLength.new(0.1, :m), dm.convert_to(:m)
    assert_equal DynamicLength.new(1, :dm), dm.convert_to(:dm)
    assert_equal DynamicLength.new(10, :cm), dm.convert_to(:cm)
    assert_equal DynamicLength.new(100, :mm), dm.convert_to(:mm)

    assert_equal DynamicLength.new(0.01, :m), cm.convert_to(:m)
    assert_equal DynamicLength.new(0.1, :dm), cm.convert_to(:dm)
    assert_equal DynamicLength.new(1, :cm), cm.convert_to(:cm)
    assert_equal DynamicLength.new(10, :mm), cm.convert_to(:mm)

    assert_equal DynamicLength.new(0.001, :m), mm.convert_to(:m)
    assert_equal DynamicLength.new(0.01, :dm), mm.convert_to(:dm)
    assert_equal DynamicLength.new(0.1, :cm), mm.convert_to(:cm)
    assert_equal DynamicLength.new(1, :mm), mm.convert_to(:mm)
  end

  test "dynamic magic conversion" do
    # DynamicMagic = Measured.build do
    #   unit :magic_missile, aliases: [:magic_missiles, "magic missile"]
    #   unit :fireball, value: "2/3 magic_missile", aliases: [:fire, :fireballs]

    #   unit :ice, value: [
    #     {
    #       conversion: ->(x) { Rational(2, 1) * x },
    #       inverse_conversion: ->(x) {  x * Rational(1, 2) },
    #       description: '2 magic missile'
    #     },
    #     "magic_missile"
    #   ]

    #   unit :arcane, value: [
    #     {
    #       conversion: ->(x) { Rational(10, 1) * x },
    #       inverse_conversion: ->(x) {  x * Rational(1, 10) },
    #       description: '10 magic missile'
    #     },
    #     "magic_missile"
    #   ]

    #   unit :ultima, value: [
    #     {
    #       conversion: ->(x) { Rational(10, 1) * x + 10},
    #       inverse_conversion: ->(x) {  (x-10) * Rational(1, 10) },
    #       description: '10 arcane + 10'
    #     },
    #     "arcane"
    #   ]
    # end

    # 1 arcane = 10 magic_missile
    # 1 ultima = 10 * arcane + 10
    # 1 ultima = 110 magic_missile

    missile = DynamicMagic.new(200, :magic_missile)
    arcane = DynamicMagic.new(1, :arcane)
    ultima = DynamicMagic.new(1, :ultima)

    assert_equal DynamicMagic.new(1, :ultima), ultima.convert_to(:ultima)
    assert_equal DynamicMagic.new(20, :arcane), ultima.convert_to(:arcane)
    assert_equal DynamicMagic.new(200, :magic_missile), ultima.convert_to(:magic_missile)

    assert_equal DynamicMagic.new(-0.9, :ultima), arcane.convert_to(:ultima)
    assert_equal DynamicMagic.new(1, :arcane), arcane.convert_to(:arcane)
    assert_equal DynamicMagic.new(10, :magic_missile), arcane.convert_to(:magic_missile)

    assert_equal DynamicMagic.new(1, :ultima), missile.convert_to(:ultima)
    assert_equal DynamicMagic.new(20, :arcane), missile.convert_to(:arcane)
    assert_equal DynamicMagic.new(200, :magic_missile), missile.convert_to(:magic_missile)
  end

  test "arithmetic operations favours unit of left" do
    left = DynamicMagic.new(1, :arcane)
    right = DynamicMagic.new(1, :magic_missile)
    arcane = DynamicMagic.unit_system.unit_for!(:arcane)

    assert_equal arcane, (left + right).unit
    assert_equal arcane, (left - right).unit
  end

  test "#coerce should return other as-is when same class" do
    assert_equal [@two, @three], @three.coerce(@two)
  end

  test "#coerce should raise TypeError when other cannot be coerced" do
    assert_raises(TypeError) { @two.coerce(2) }
    assert_raises(TypeError) { @three.coerce(5.2) }
    assert_raises(TypeError) { @four.coerce(Object.new) }
  end
end
