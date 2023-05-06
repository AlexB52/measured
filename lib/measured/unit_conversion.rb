# frozen_string_literal: true

module Measured
  class DynamicUnitConversion
    attr_reader :amount, :unit

    def initialize(amount:, unit:, conversion_string: nil)
      @amount = amount
      @unit = unit
      @conversion_string = conversion_string
    end

    def dynamic?
      true
    end

    def static?
      false
    end

    def to_s
      @conversion_string
    end

    def inverse_amount
      return unless amount

      ->(x) { 1 / amount.call(x) }
    end
  end

  class StaticUnitConversion
    attr_reader :amount, :unit

    def initialize(amount:, unit:)
      @amount = amount
      @unit = unit
    end

    def dynamic?
      false
    end

    def static?
      true
    end

    def to_s
      return unless amount && unit

      "#{amount} #{unit}"
    end

    def inverse_amount
      return unless amount

      (1 / amount)
    end
  end

  class UnitConversion
    def self.parse(tokens, conversion_string: nil)
      if tokens.nil?
        return StaticUnitConversion.new(amount: nil, unit: nil)
      end

      case tokens
      when String
        tokens = Measured::Parser.parse_string(tokens)
      when Array
        raise Measured::UnitError, "Cannot parse [number, unit] formatted tokens from #{tokens}." unless tokens.size == 2
      else
        raise Measured::UnitError, "Unit must be defined as string or array, but received #{tokens}"
      end

      case tokens[0]
      when Proc
        DynamicUnitConversion.new(
          amount: tokens[0],
          unit: tokens[1].freeze,
          conversion_string: conversion_string
        )
      else
        StaticUnitConversion.new(
          amount: tokens[0].to_r,
          unit: tokens[1].freeze
        )
      end
    end
  end
end
