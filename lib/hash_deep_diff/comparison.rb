# frozen_string_literal: true

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right

    def diff(&block)
      return [{}, {}, {}] if left == right  # this is order-sensitive comparison
      return [left, {}, {}] if right.empty?
      return [{}, {}, right] if left.empty?
      return first_level_delta(&block) if one_level_deep?

      return nil
    end

    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end

    def first_level_delta(&block)
      [
        left_delta,
        delta(&block),
        right_delta
      ]
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

    def one_level_deep?
      left.values.none? { |value| value.respond_to?(:to_hash) } &&
        right.values.none? { |value| value.respond_to?(:to_hash) }
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
