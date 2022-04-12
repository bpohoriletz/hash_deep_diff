# frozen_string_literal: true

require_relative 'delta/left'
require_relative 'delta/inner'
require_relative 'delta/right'

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right, :path

    def diff(&block)
      left_delta + deep_delta(&block) + right_delta
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

    def deep_delta(&block)
      result = delta(&block)

      result.each_with_object([]) do |diff, memo|
        if left.dig(*diff.path).respond_to?(:to_hash) && right.dig(*diff.path).respond_to?(:to_hash)
          self.class.new(left.dig(*diff.path), right.dig(*diff.path), path + diff.path).diff.each do |diff|
            memo << diff
          end
        else
          memo << diff
        end
      end
    end

    def right_delta
      right_diff_keys.map { |key| Delta::Right.new(path: path + [key], value: right[key]) }
    end

    def delta(&block)
      block ||= ->(val) { val }

      common_keys.each_with_object([]) do |key, memo|
        value_left = block.call(left[key])
        value_right = block.call(right[key])

        next if value_right.instance_of?(value_left.class) && (value_right == value_left)

        memo << Delta::Inner.new(path: path + [key], value: { left: value_left, right: value_right })
      end
    end

    def left_delta
      left_diff_keys.map { |key| Delta::Left.new(path: path + [key], value: left[key]) }
    end

    def common_keys
      left.keys & right.keys
    end

    def right_diff_keys
      right.keys - left.keys
    end

    def left_diff_keys
      left.keys - right.keys
    end
  end
end
