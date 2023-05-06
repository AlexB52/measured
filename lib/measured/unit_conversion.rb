# frozen_string_literal: true

module Measured
  class UnitConversion
    attr_reader :amount, :inverse_amount, :unit

    def initialize(value)
      @value = value
      @amount, @unit = parse_value(value) if value
      @inverse_amount = (1 / amount if amount)
    end

    def to_s
      return unless amount && unit

      "#{amount} #{unit}"
    end

    private

    def parse_value(tokens)
      case tokens
      when String
        tokens = Measured::Parser.parse_string(tokens)
      when Array
        raise Measured::UnitError, "Cannot parse [number, unit] formatted tokens from #{tokens}." unless tokens.size == 2
      else
        raise Measured::UnitError, "Unit must be defined as string or array, but received #{tokens}"
      end

      [tokens[0].to_r, tokens[1].freeze]
    end
  end
end
