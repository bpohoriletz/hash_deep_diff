# frozen_string_literal: true

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right

    def diff
      return {} if left == right  # this is rder-sensitive comparison
      return left if right.empty?
      return right if left.empty?

      return {}
    end

    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end
  end
end
