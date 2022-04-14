# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the inner diff
    # i.e element is predent on both left and right and value is different
    # examples:
    #   - inner diff of { a: a } and {} is { a: { left: a, right: HashDeepDiff::NO_VALUE } }
    #   - inner diff of { a: a } and { a: b } is { a: { left: a, right: b } }
    #   - inner diff of {} and { a: b } is { a: { left: HashDeepDiff::NO_VALUE, right: b } }
    class Inner
      include Delta::ActsAsDelta

      def to_str
        [deletion, addition].compact.join("\n")
      end

      def complex?
        left.respond_to?(:to_hash) && right.respond_to?(:to_hash)
      end

      def deletion
        return nil if left == NO_VALUE

        if left.respond_to?(:to_hash)
          left.keys.map { |key| "-left#{diff_prefix}[#{key}] = #{left[key]}" }.join("\n")
        else
          "-left#{diff_prefix} = #{left}"
        end
      end

      def addition
        return nil if right == NO_VALUE

        if right.respond_to?(:to_hash)
          right.keys.map { |key| "+left#{diff_prefix}[#{key}] = #{right[key]}" }.join("\n")
        else
          "+left#{diff_prefix} = #{right}"
        end
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
