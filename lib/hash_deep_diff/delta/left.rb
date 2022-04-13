# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the pure left diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example left diff of { a: a } and {} is { a: a }
    class Left
      include Delta::ActsAsDelta

      def to_str
        return "+left#{diff_prefix} = #{left}" unless left.respond_to?(:to_hash)

        left.keys.map do |key|
          self.class.new(path: path + [key], value: left[key])
        end.join("\n").strip
      end

      def left
        @delta.values.first
      end

      def right
        nil
      end
    end
  end
end
