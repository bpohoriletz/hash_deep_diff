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

    def to_str
      [deletion, addition].compact.join("\n")
    end

    def complex?
      left.respond_to?(:to_hash) && right.respond_to?(:to_hash)
    end

    def path
      @prefix + [@delta.keys.first]
    end

    def left
      @value[:left]
    end

    def right
      @value[:right]
    end

    def to_s
      to_str
    end

    private

    def initialize(path:, value:)
      # TOFIX this may prohibit usage of hashes with Array keys
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

    def deletion
      return nil if left == NO_VALUE

      Report.new(path: path, value: left, mode: Report::Mode::DELETION)
    end

    def addition
      return nil if right == NO_VALUE

      Report.new(path: path, value: right)
    end
  end
end
