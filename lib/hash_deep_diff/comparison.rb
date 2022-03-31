# frozen_string_literal: true

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right

    def diff
      return [{}, {}, {}] if left == right  # this is order-sensitive comparison
      return [left, {}, {}] if right.empty?
      return [{}, {}, right] if left.empty?
      return first_level_delta if one_level_deep?

      return nil
    end

    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end

    def first_level_delta
      [
        left_delta,
        delta,
        right_delta
      ]
    end

    def right_delta
      right_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = right[key]
      end
    end

    def delta
      common_keys.each_with_object({}) do |key, memo|
        next if right[key] == left[key]

        memo[key] = {
          left: left[key],
          right: right[key]
        }
      end
    end

    def left_delta
      left_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = left[key]
      end
    end

    def one_level_deep?
      left.values.none? { |value| value.respond_to?(:to_ary) || value.respond_to?(:to_hash) } &&
        right.values.none? { |value| value.respond_to?(:to_ary) || value.respond_to?(:to_hash) }
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
