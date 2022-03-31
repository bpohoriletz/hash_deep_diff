# frozen_string_literal: true

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end
  end
end
