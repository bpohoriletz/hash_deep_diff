# frozen_string_literal: true

require_relative 'acts_as_hash'

module HashDeepDiff
  module Delta
    # Representation of the pure right diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example right diff of {} and { a: a } is { a: a }
    class Right
      include Delta::ActsAsHash
      attr_reader :delta

      private

      def initialize(delta: {})
        @delta = delta.to_hash
      end
    end
  end
end
