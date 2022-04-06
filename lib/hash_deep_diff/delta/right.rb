# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  module Delta
    # Representation of the pure right diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example right diff of {} and { a: a } is { a: a }
    class Right
      extend Forwardable
      attr_reader :delta

      def_delegators :@delta, :to_s, :inspect, :==, :each_with_object, :each_key, :[], :to_a, :empty?

      def to_h
        delta
      end

      def to_hash
        delta
      end

      private

      def initialize(delta: {})
        @delta = delta.to_hash
      end
    end
  end
end
