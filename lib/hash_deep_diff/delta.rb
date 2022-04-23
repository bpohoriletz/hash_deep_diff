# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # Representation of the diff of two values
  # examples:
  #   - diff of { a: a } and {} is { a: { left: a, right: HashDeepDiff::NO_VALUE } }
  #   - diff of { a: a } and { a: b } is { a: { left: a, right: b } }
  #   - diff of {} and { a: b } is { a: { left: HashDeepDiff::NO_VALUE, right: b } }
  class Delta
    extend Forwardable

    def_delegators :@delta, :==, :each_with_object, :each_key, :[],
                   :to_a, :empty?, :keys
    # Returns true if we have nested Hashes
    # @return [Bool]
    def complex?
      !simple_left? || !simple_right?
    end

    # Returns true if left value has no nested Hashes
    # @return [Bool]
    def simple_left?
      !left.respond_to?(:to_hash)
    end

    # Returns true if right value has no nested Hashes
    # @return [Bool]
    def simple_right?
      !right.respond_to?(:to_hash)
    end

    # Keys needed to fetch values that we're comparing
    # @return [Array]
    def path
      prefix + [delta.keys.first]
    end

    # Original value
    def left
      value[:left]
    end

    # Value we compare to
    def right
      value[:right]
    end

    # see {#to_hash}
    # @return [Hash]
    def to_h
      to_hash
    end

    # @return [Hash]
    def to_hash
      delta
    end

    private

    attr_reader :delta, :prefix, :value

    # @param [Array] path list of keys to fetch values we're comparing
    # @param [Hash<(:left, :right), Object>] value +Hash+ object with two keys - :left and :right,
    #   that represents compared original value (at :left) and value we compare to (at :right)
    def initialize(path:, value:)
      @delta = { path[-1] => value }
      @value = value
      @prefix = path[0..-2]
    end
  end
end
