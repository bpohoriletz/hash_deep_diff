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
        "+left#{diff_prefix} = #{@delta.values.first}"
      end
    end
  end
end
