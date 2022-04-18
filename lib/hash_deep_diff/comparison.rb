# frozen_string_literal: true

require_relative 'delta'

# :nodoc:
module HashDeepDiff
  # Representation of the recursive difference between two hashes
  # main parts are
  # * path - empty for original hashes, otherwise path to values being compared
  # * left - basically left.dig(path), left value of two being compared
  # * right - basically right.dig(path), right value of two being compared
  #
  # Examples:
  #   - { one: a } compared with { one: b } does not have nesting so we compare keys and values
  #   - { one: { two: a, zero: z } } compared with { one: { two: b, three: c } } has nesting, so is represented as
  #     - { two: a } compared with { two: b, three: c }, as there is no more nesting we compare keys and values
  #       and have the following comparisons
  #       { one: { two: a } } compared to { one: { two: b } } - value was changed
  #       { one: { zero: z } } compared to NO_VALUE - value was deleted
  #       NO_VALUE comared to { one: { three: c } } compared - value was added
  class Comparison
    attr_reader :left, :right, :path

    def diff
      nested_deltas
    end

    def report
      diff.join("\n")
    end

    private

    def initialize(left, right, path = [])
      @left = left.to_hash
      @right = right.to_hash
      @path = path.to_ary
    end

    def nested_deltas
      comparison.flat_map do |delta|
        # if there are nested hashes we need to compare them furter
        # if no we return difference between values (HashDeepDiff::Delta)
        delta.complex? ? self.class.new(delta.left, delta.right, delta.path).diff : delta
      end
    end

    def comparison
      common_keys.each_with_object([]) do |key, memo|
        next if values_equal?(key)

        memo << Delta.new(path: path + [key], value: { left: value_left(key), right: value_right(key) })
      end
    end

    def values_equal?(key)
      value_right(key).instance_of?(value_left(key).class) && (value_right(key) == value_left(key))
    end

    def value_left(key)
      left[key] || NO_VALUE
    end

    def value_right(key)
      right[key] || NO_VALUE
    end

    def common_keys
      (left.keys + right.keys).uniq
    end
  end
end
