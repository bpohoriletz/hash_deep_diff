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

    def_delegators :to_hash, :==, :each_with_object, :each_key, :[],
                   :to_a, :empty?, :keys
    attr_reader :change_key

    # an indication that nested Hash was deleted/added
    # @return [Array<HashDeepDiff::Delta>]
    def placebo
      placebo = simple_left? ? { left: NO_VALUE, right: placebo_elment } : { left: placebo_elment, right: NO_VALUE }

      [self.class.new(path: change_key, value: placebo)]
    end

    # true if any value is an +Array+ with hashes
    # @return [TrueClass, FalseClass]
    def complex?
      complex_left? || complex_right?
    end

    # true if right part is an +Array+ with hashes
    # @return [TrueClass, FalseClass]
    def complex_right?
      right.respond_to?(:to_ary) && right.any? { |el| el.respond_to?(:to_hash) }
    end

    # true if left part is an +Array+ with hashes
    # @return [TrueClass, FalseClass]
    def complex_left?
      left.respond_to?(:to_ary) && left.any? { |el| el.respond_to?(:to_hash) }
    end

    # true if at least one of the values is a Hash
    # @return [TrueClass, FalseClass]
    def partial?
      !composite? && !simple? && !complex_left? && !complex_right?
    end

    # true if both valus are Hashes
    # @return [TrueClass, FalseClass]
    def composite?
      !simple_left? && !simple_right?
    end

    # true if none of the values is a Hash
    # @return [TrueClass, FalseClass]
    def simple?
      simple_left? && simple_right?
    end

    # removed element(s)
    def deletion
      return left unless array_with_array?

      return left - right
    end

    # Original value
    def left
      value[:left]
    end

    # added element(s)
    def addition
      return right unless array_with_array?

      return right - left
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
      { change_key[-1] => value }
    end

    private

    attr_reader :value

    # @param [Array] path list of keys to fetch values we're comparing
    # @param [Hash<(:left, :right), Object>] value +Hash+ object with two keys - :left and :right,
    #   that represents compared original value (at :left) and value we compare to (at :right)
    def initialize(path:, value:)
      @value = value
      @change_key = HashDeepDiff::ChangeKey.new(path: path)
    end

    # an indication of added/removed nested Hash
    # @return [Array, Hash]
    def placebo_elment
      return [{}] if complex_left? || complex_right?

      return {}
    end

    # true if left value has no nested Hashes
    # @return [TrueClass, FalseClass]
    def simple_left?
      !left.respond_to?(:to_hash) && !complex_left?
    end

    # true if right value has no nested Hashes
    # @return [TrueClass, FalseClass]
    def simple_right?
      !right.respond_to?(:to_hash) && !complex_right?
    end

    # true if both left and right are arrays
    # @return [TrueClass, FalseClass]
    def array_with_array?
      left.respond_to?(:to_ary) && right.respond_to?(:to_ary)
    end
  end
end
