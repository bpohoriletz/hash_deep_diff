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

    def extra_report(memo, keys, value)
      if value.respond_to?(:to_hash)
        value.each_key { |key| extra_report(memo, keys + [key], value[key]) }
      else
        memo << Delta::Left.new(path: keys, value: value)
      end
    end

    def missing_report(memo, keys, value)
      if value.respond_to?(:to_hash)
        value.each_key { |key| missing_report(memo, keys + [key], value[key]) }
      else
        memo << Delta::Right.new(path: keys, value: value)
      end
    end

    def delta_report(memo, keys, value)
      if value.respond_to?(:to_hash) && value.keys != %i[left right]
        value.each_key { |key| delta_report(memo, keys + [key], value[key]) }
      elsif value.instance_of?(Array) && value.size == 3 && value.all? { |el| el.respond_to?(:to_hash) }
        # [{}, {}, {:i=>:i}]
        extra_report(memo, keys, value[0]) unless value[0].empty?
        delta_report(memo, keys, value[1]) unless value[1].empty?
        missing_report(memo, keys, value[2]) unless value[2].empty?
      else
        memo << Delta::Inner.new(path: keys, value: value)
      end
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
      right_diff_keys.each_with_object([]) do |key, memo|
        memo << Delta::Right.new(path: path + [key], value: right[key])
      end
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
      left_diff_keys.each_with_object([]) do |key, memo|
        memo << Delta::Left.new(path: path + [key], value: left[key])
      end
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
