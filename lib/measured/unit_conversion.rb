# frozen_string_literal: true

module Measured
  class UnitConversion
    attr_reader :amount, :inverse_amount, :unit

    def initialize(value, conversion_string: nil)
      @value = value
      @amount, @unit = parse_value(value) if value
      @conversion_string = conversion_string
    end

    def to_s
      return @conversion_string if @conversion_string
      return unless amount && unit

      case amount
      when Proc
      else
        "#{amount} #{unit}"
      end

    end

    def inverse_amount
      return @inverse_amount if instance_variable_defined?("@inverse_amount")
      return unless amount

      @inverse_amount ||= begin
        case amount
        when Proc
          ->(x) { 1 / amount.call(x) }
        else
          (1 / amount)
        end
      end
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

      case tokens[0]
      when Proc
        [tokens[0], tokens[1].freeze]
      else
        [tokens[0].to_r, tokens[1].freeze]
      end
    end
  end
end
