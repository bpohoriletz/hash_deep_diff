# frozen_string_literal: true

require_relative 'acts_as_hash'

module HashDeepDiff
  module Delta
    # Representation of the pure left diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example left diff of { a: a } and {} is { a: a }
    class Left
      include Delta::ActsAsHash
      attr_reader :delta

      def to_s
        to_str
      end

      def to_str
        "+left[#{delta.keys.first}] = #{delta.values.first}"
      end

      private

      def initialize(delta: {})
        @delta = delta.to_hash
      end
    end
  end
end
