# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  module Delta
    # Representation of the pure left diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example left diff of { a: a } and {} is { a: a }
    class Left
      extend Forwardable
      attr_reader :delta
      def_delegators :@delta, :to_s, :inspect

      private

      def initialize(delta: {})
        @delta = delta
      end
    end
  end
end
