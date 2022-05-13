# frozen_string_literal: true

require_relative 'factories/comparison'

module HashDeepDiff
  # Representation of the recursive difference between two hashes
  # main parts are
  # * path - empty for original hashes, otherwise path to values being compared
  # * left - basically left.dig(path), left value of two being compared
  # * right - basically right.dig(path), right value of two being compared
  #
  # Examples:
  #   - { one: :a } compared with { one: :b } does not have nesting so we compare keys and values
  #   - { one: { two: :a, zero: :z } } compared with { one: { two: :b, three: :c } } has nesting, so is represented as
  #     - { two: :a } compared with { two: :b, three: :c }, as there is no more nesting we compare keys and values
  #       and have the following comparisons
  #       { one: { two: :a } } compared to { one: { two: :b } } - value was changed
  #         i.e :a vas replaced with :b on path [:one, :two]
  #       { one: { zero: :z } } compared to NO_VALUE - value was deleted
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
    extend Forwardable
    # @!attribute [r] left
    #    @return [Hash] original version of the Hash
    # @!attribute [r] right
    #    @return [Hash] Hash that the original is compared to
    # @!attribute [r] path
    #    @return [Array<Object>] subset of keys from original Hashes to fetch compared values
    #    (is empty for top-level comparison)
    attr_reader :reporting_engine, :delta_engine

    def_delegators :comparison_factory, :comparison
    def_delegators :report_engine_factory, :report

    # @return [Array<HashDeepDiff::Delta>]
    def diff
      return [] if left == right

      deltas.flat_map { |new_delta| new_delta.simple? ? new_delta : inward_comparison(new_delta) }
    end

    # @param [Object] key the key which value we're currently comparing
    def left(key = NO_VALUE)
      return NO_VALUE if @left == NO_VALUE
      return @left if key == NO_VALUE
      return @left unless left.respond_to?(:to_hash)

      @left[key] || NO_VALUE
    end

    # @param [Object] key the key which value we're currently comparing
    def right(key = NO_VALUE)
      return NO_VALUE if @right == NO_VALUE
      return @right if key == NO_VALUE
      return @right unless right.respond_to?(:to_hash)

      @right[key] || NO_VALUE
    end

    private

    attr_reader :path

    # @param [Object] original original version
    # @param [Object] changed new version
    # @param [Array] prefix keys to fetch current comparison (not empty for nested comparisons)
    def initialize(original, changed, prefix = [], reporting_engine: Reports::Diff, delta_engine: Delta)
      @left = original
      @right = changed
      @path = prefix.to_ary
      @reporting_engine = reporting_engine
      @delta_engine = delta_engine
    end

    # {Comparison} broken down into array of {Delta}
    # @return [Array<HashDeepDiff::Delta>]
    def deltas
      return [delta] if common_keys.empty?

      common_keys.each_with_object([]) do |key, memo|
        next if values_equal?(key)

        memo.append(delta(key: key))
      end.flatten
    end

    # depending on circumstances will return necessary comparisons
    # @return [Array<HashDeepDiff::Delta>]
    def inward_comparison(complex_delta)
      if complex_delta.partial?
        complex_delta.placebo +
          comparison(delta: complex_delta, modifier: :addition).map(&:diff).flatten +
          comparison(delta: complex_delta, modifier: :deletion).map(&:diff).flatten
      else
        comparison(delta: complex_delta).map(&:diff).flatten
      end
    end

    # @param [Object] key the key which value we're currently comparing
    # @return [Bool]
    def values_equal?(key)
      right(key).instance_of?(left(key).class) && (right(key) == left(key))
    end

    # All keys from both original and compared objects
    # @return [Array]
    def common_keys
      keys = []
      keys += left.keys if left.respond_to?(:keys)
      keys += right.keys if right.respond_to?(:keys)

      keys.uniq
    end

    # factory function
    # @return [HashDeepDiff::Delta]
    def delta(key: NO_VALUE)
      change_key = path
      change_key += [key] unless key == NO_VALUE

      HashDeepDiff::Delta.new(change_key: change_key, value: { left: left(key), right: right(key) })
    end

    # @return [HashDeepDiff::Factories::Comparison]
    def comparison_factory
      HashDeepDiff::Factories::Comparison.new(reporting_engine: reporting_engine)
    end

    # @return [HashDeepDiff::Reports::Base]
    def report_engine_factory
      reporting_engine.new(diff: diff)
    end
  end
end
