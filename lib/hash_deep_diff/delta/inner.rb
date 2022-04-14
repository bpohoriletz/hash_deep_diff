# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the inner diff
    # i.e element is predent on both left and right and value is different
    # for example inner diff of { a: a } and { a: b } is { a: { left: a, right: b } }
    class Inner
      include Delta::ActsAsDelta

      def to_str
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
