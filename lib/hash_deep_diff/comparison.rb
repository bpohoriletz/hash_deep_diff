# frozen_string_literal: true

require_relative 'delta/left'
require_relative 'delta/inner'
require_relative 'delta/right'

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right

    EMPTY_DELTA = -> { [Delta::Left.new, Delta::Inner.new, Delta::Right.new] }.freeze
    LEFT_DELTA = ->(delta) { [Delta::Left.new(delta: delta), Delta::Inner.new, Delta::Right.new] }.freeze
    RIGHT_DELTA = ->(delta) { [Delta::Left.new, Delta::Inner.new, Delta::Right.new(delta: delta)] }.freeze

    def diff(&block)
      return EMPTY_DELTA.call if left == right # this is order-sensitive comparison
      return LEFT_DELTA.call(left) if right.empty?
      return RIGHT_DELTA.call(right) if left.empty?

      return [left_delta, deep_delta(&block), right_delta]
    end

    def report(&block)
      extra, delta, missing = diff(&block)

      lines = extra.each_with_object([]) do |(key, value), memo|
        if value.respond_to?(:to_hash)
          extra_report(memo, [key], value)
        else
          memo << Delta::Left.new(delta: { key => value })
        end
      end

      lines += missing.each_with_object([]) do |(key, value), memo|
        if value.respond_to?(:to_hash)
          missing_report(memo, [key], value)
        else
          memo << Delta::Right.new(delta: { key => value })
        end
      end

      lines += delta.each_with_object([]) do |(key, value), memo|
        if value.instance_of?(Array)
          delta_report(memo, [key], value[1])
        else
          memo << Delta::Inner.new(delta: { key => value })
        end
      end

      return lines.join("\n")
    end

    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end

    def extra_report(memo, keys, value)
      if value.respond_to?(:to_hash)
        value.each_key do |key|
          extra_report(memo, keys + [key], value[key])
        end
      else
        path = keys.map { |key| "[#{key}]" }.join
        memo << "+left#{path} = #{value}"
      end
    end

    def missing_report(memo, keys, value)
      if value.respond_to?(:to_hash)
        value.each_key do |key|
          missing_report(memo, keys + [key], value[key])
        end
      else
        path = keys.map { |key| "[#{key}]" }.join
        memo << "-left#{path} = #{value}"
      end
    end

    def delta_report(memo, keys, value)
      if value.respond_to?(:to_hash) && value.keys != %i[left right]
        value.each_key do |key|
          delta_report(memo, keys + [key], value[key])
        end
      elsif value.instance_of?(Array) && value.size == 3 && value.all? { |el| el.respond_to?(:to_hash) }
        # [{}, {}, {:i=>:i}]
        extra_report(memo, keys, value[0]) unless value[0].empty?
        delta_report(memo, keys, value[1]) unless value[1].empty?
        missing_report(memo, keys, value[2]) unless value[2].empty?
      else
        path = keys.map { |key| "[#{key}]" }.join
        line = <<~Q
          -left#{path} = #{value[:left]}
          +right#{path} = #{value[:right]}
        Q
        memo << line
      end
    end

    def deep_delta(&block)
      result = delta(&block)

      result.keys.each_with_object({}) do |key, memo|
        memo[key] = if left[key].respond_to?(:to_hash) && right[key].respond_to?(:to_hash)
                      self.class.new(left[key], right[key]).diff
                    else
                      result[key]
                    end
      end
    end

    def right_delta
      right_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = right[key]
      end
    end

    def delta(&block)
      block ||= ->(val) { val }

      common_keys.each_with_object({}) do |key, memo|
        value_left = block.call(left[key])
        value_right = block.call(right[key])

        next if value_right.instance_of?(value_left.class) && (value_right == value_left)

        memo[key] = {
          left: value_left,
          right: value_right
        }
      end
    end

    def left_delta
      left_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = left[key]
      end
    end

    def common_keys
      left.keys & right.keys
    end

    def right_diff_keys
      right.keys - left.keys
    end

    def left_diff_keys
      left.keys - right.keys
    end
  end
end
