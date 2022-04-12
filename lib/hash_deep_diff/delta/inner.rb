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
        if @delta.values.first.respond_to?(:to_hash)
          if @delta.values.first.keys == %i[left right]
            if complex?
              HashDeepDiff::Comparison.new(left, right, path).report
            else
              lines = <<~Q
                -left#{diff_prefix} = #{left}
                +right#{diff_prefix} = #{right}
              Q
              lines.strip
            end
          else
            @delta.values.first.keys.map do |key|
              self.class.new(path: path + [key], value: @delta.values.first[key])
            end.join("\n").strip
          end
        else
          lines = <<~Q
            -left#{diff_prefix} = #{left}
            +right#{diff_prefix} = #{right}
          Q
          lines.strip
        end
      end

      def complex?
        left.respond_to?(:to_hash) && right.respond_to?(:to_hash)
      end

      def left
        @delta.values.first[:left]
      end

      def right
        @delta.values.first[:right]
      end
    end
  end
end
