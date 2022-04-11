# frozen_string_literal: true

require_relative 'acts_as_delta'

module HashDeepDiff
  module Delta
    # Representation of the pure right diff
    # i.e element that are missing in the hash on the right of the comparison
    # for example right diff of {} and { a: a } is { a: a }
    class Right
      include Delta::ActsAsDelta

      def to_str
        "-left#{path} = #{@delta.values.first}"
      end
    end
  end
end
