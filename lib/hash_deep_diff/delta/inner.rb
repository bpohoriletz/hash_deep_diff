# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the pure left diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example left diff of { a: a } and {} is { a: a }
    class Inner
      include Delta::ActsAsDelta
      attr_reader :delta

      def to_s
        to_str
      end

      def to_str
        lines = <<~Q
          -left[#{delta.keys.first}] = #{delta.values.first[:left]}
          +right[#{delta.keys.first}] = #{delta.values.first[:right]}
        Q
        lines.strip
      end

      private

      def initialize(delta: {})
        @delta = delta.to_hash
      end
    end
  end
end
