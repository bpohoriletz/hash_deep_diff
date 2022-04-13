# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the pure left diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example left diff of { a: a } and {} is { a: a }
    class Inner
      include Delta::ActsAsDelta

      def to_str
        return diff unless complex?

        HashDeepDiff::Comparison.new(left, right, path).report
      end

      def diff
        lines = <<~Q
          -left#{diff_prefix} = #{left}
          +right#{diff_prefix} = #{right}
        Q
        lines.strip
      end

      def complex?
        left.respond_to?(:to_hash) && right.respond_to?(:to_hash)
      end

      def left
        @value[:left]
      end

      def right
        @value[:right]
      end
    end
  end
end
