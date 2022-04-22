# frozen_string_literal: true

require_relative 'acts_as_hash'
require_relative 'report'

module HashDeepDiff
  # Representation of the diff of two values
  # examples:
  #   - diff of { a: a } and {} is { a: { left: a, right: HashDeepDiff::NO_VALUE } }
  #   - diff of { a: a } and { a: b } is { a: { left: a, right: b } }
  #   - diff of {} and { a: b } is { a: { left: HashDeepDiff::NO_VALUE, right: b } }
  class Delta
    include ActsAsHash

    # Visual representation of additions and deletiond at given +path+
    # @return [String]
    def to_str
      Report.new(path: path, value: left, mode: Report::Mode::DELETION).to_s +
        Report.new(path: path, value: right, mode: Report::Mode::ADDITION).to_s
    end

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
      @prefix + [@delta.keys.first]
    end

    # Original value
    def left
      @value[:left]
    end

    # Value we compare to
    def right
      @value[:right]
    end

    # See {#to_str}
    def to_s
      to_str
    end

    private

    # @param [Array, Object] path list of keys to fetch values we're comparing
    # @param [Hash<(:left, :right), Object>] value +Hash+ object with two keys - :left and :right,
    #   that represents compared original value (at :left) and value we compare to (at :right)
    def initialize(path:, value:)
      # TOFIX this may prohibit usage of hashes with Array keys
      # TOFIX extract path to a separate object
      if path.respond_to?(:to_ary)
        @delta = { path[-1] => value }
        @value = value
        @prefix = path[0..-2]
      else
        @delta = { path => value }
        @value = value
        @prefix = []
      end
    end
  end
end
