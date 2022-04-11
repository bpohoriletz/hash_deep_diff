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
        lines = <<~Q
          -left#{path} = #{delta.values.first[:left]}
          +right#{path} = #{delta.values.first[:right]}
        Q
        lines.strip
      end
    end
  end
end
