# frozen_string_literal: true

require_relative 'delta'

# :nodoc:
module HashDeepDiff
  # An instrument to build and report the difference between two hash-like objects
  class Comparison
    attr_reader :left, :right, :path

    def diff
      deep_delta
    end

    def report
      diff.join("\n")
    end

    private

    def initialize(left, right, path = [])
      @left = left.to_hash
      @right = right.to_hash
      @path = path.to_ary
    end

    def deep_delta
      delta.flat_map do |diff|
        if diff.complex?
          self.class.new(diff.left, diff.right, diff.path).diff
        else
          diff
        end
      end
    end

    def delta
      common_keys.each_with_object([]) do |key, memo|
        value_left = left[key] || NO_VALUE
        value_right = right[key] || NO_VALUE

        next if value_right.instance_of?(value_left.class) && (value_right == value_left)

        memo << Delta.new(path: path + [key], value: { left: value_left, right: value_right })
      end
    end

    def common_keys
      (left.keys + right.keys).uniq
    end
  end
end
