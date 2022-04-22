# frozen_string_literal: true

require_relative 'delta'

module HashDeepDiff
  # Representation of the recursive difference between two hashes
  # main parts are
  # * path - empty for original hashes, otherwise path to values being compared
  # * left - basically left.dig(path), left value of two being compared
  # * right - basically right.dig(path), right value of two being compared
  #
  # Examples:
  #   - { one: :a } compared with { one: :b } does not have nesting so we compare keys and values
  #   - { one: { two: :a, zero: z } } compared with { one: { two: :b, three: :c } } has nesting, so is represented as
  #     - { two: :a } compared with { two: :b, three: :c }, as there is no more nesting we compare keys and values
  #       and have the following comparisons
  #       { one: { two: :a } } compared to { one: { two: :b } } - value was changed
  #         i.e :a vas replaced with :b on path [:one, :two]
  #       { one: { zero: z } } compared to NO_VALUE - value was deleted
  #         i.e :z vas replaced with NO_VALUE on path [:one, :zero]
  #       NO_VALUE compared to { one: { three: :c } } compared - value was added
  #         i.e NO_VALUE vas replaced with :c on path [:one, :three]
  #  [
  #    #<HashDeepDiff::Delta
  #      @delta={:two=>{:left=>:a, :right=>:b}},
  #      @prefix=[:one],
  #      @value={:left=>:a, :right=>:b}>,
  #    #<HashDeepDiff::Delta
  #      @delta={:zero=>{:left=>:z, :right=>HashDeepDiff::NO_VALUE}},
  #      @prefix=[:one],
  #      @value={:left=>:z, :right=>HashDeepDiff::NO_VALUE}>,
  #    #<HashDeepDiff::Delta
  #     @delta={:three=>{:left=>HashDeepDiff::NO_VALUE, :right=>:c}},
  #     @prefix=[:one],
  #     @value={:left=>HashDeepDiff::NO_VALUE, :right=>:c}>
  #  ]
  class Comparison
    # @!attribute [r] left
    #    @return [Hash] original version of the Hash
    # @!attribute [r] right
    #    @return [Hash] Hash that the original is compared to
    # @!attribute [r] path
    #    @return [Array<Object>] subset of keys from original Hashes to fetch compared Hashes
    #    (is empty for top-level comparison)
    attr_reader :left, :right, :path

    # @return [String]
    def report
      diff.map { |delta| reporting_engine.new(delta: delta).to_s }.join
    end

    # @return [Array<HashDeepDiff::Delta>]
    def diff
      comparison.map do |delta|
        if delta.complex? && (delta.simple_right? || delta.simple_left?)
          missing_mesting(delta)
        elsif delta.complex?
          self.class.new(delta.left, delta.right, delta.path).diff
        else
          delta
        end
      end.flatten
    end

    private

    attr_reader :reporting_engine

    # @param [Object] left original version
    # @param [Object] right new version
    # @param [Array] prefix keys to fetch current comparison (not empty for nested comparisons)
    def initialize(left, right, prefix = [], reporting_engine: Report)
      @left = left
      @right = right
      @path = prefix.to_ary
      @reporting_engine = reporting_engine
    end

    # @return [Array<HashDeepDiff::Delta>]
    def comparison
      return [Delta.new(path: path, value: { left: left, right: right })] if common_keys.empty?

      common_keys.each_with_object([]) do |key, memo|
        next if values_equal?(key)

        memo << Delta.new(path: path + [key], value: { left: value_left(key), right: value_right(key) })
      end
    end

    # if old value was a +Hash+ and new is not (or vice versa) we report +Hash+ addition/deletion
    # @param [Delta] delta
    # @return [Array<Delta>]
    def missing_mesting(delta)
      change = if delta.simple_left?
                 Delta.new(path: delta.path, value: { left: NO_VALUE, right: {} })
               elsif delta.simple_right?
                 Delta.new(path: delta.path, value: { left: {}, right: NO_VALUE })
               end
      [
        change,
        self.class.new(NO_VALUE, delta.right, delta.path).diff,
        self.class.new(delta.left, NO_VALUE, delta.path).diff
      ]
    end

    # @param [Object] key the key which value we're currently comparing
    # @return [Bool]
    def values_equal?(key)
      value_right(key).instance_of?(value_left(key).class) && (value_right(key) == value_left(key))
    end

    # @param [Object] key the key which value we're currently comparing
    def value_left(key)
      return NO_VALUE if left == NO_VALUE

      left[key] || NO_VALUE
    end

    # @param [Object] key the key which value we're currently comparing
    def value_right(key)
      return NO_VALUE if right == NO_VALUE

      right[key] || NO_VALUE
    end

    # All keys from both original and compared objects
    # @return [Array]
    def common_keys
      keys = []
      keys += left.keys if left.respond_to?(:keys)
      keys += right.keys if right.respond_to?(:keys)

      keys.uniq
    end
  end
end
