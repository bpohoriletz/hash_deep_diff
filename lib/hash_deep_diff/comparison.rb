# frozen_string_literal: true

# :nodoc:
module HashDeepDiff
  # :nodoc:
  class Comparison
    attr_reader :left, :right

    def diff(&block)
      return [{}, {}, {}] if left == right # this is order-sensitive comparison
      return [left, {}, {}] if right.empty?
      return [{}, {}, right] if left.empty?
      return first_level_delta(&block) if one_level_deep?

      return [left_delta, deep_delta(&block), right_delta]
    end

    def report(&block)
      extra, delta, missing = diff(&block)

      lines = extra.each_with_object([]) do |(key, value), memo|
        if value.instance_of?(Hash)
          extra_report(memo, [key], value)
        else
          memo << "+left[#{key}] = #{value}"
        end
      end

      lines += missing.each_with_object([]) do |(key, value), memo|
        if value.instance_of?(Hash)
          missing_report(memo, [key], value)
        else
          memo << "-left[#{key}] = #{value}"
        end
      end

      lines += delta.each_with_object([]) do |(key, value), memo|
        if value.instance_of?(Array)
          # value = [{}, {}, {}]
          delta_report(memo, [key], value[1])
        else
          line = <<~Q
            -left[#{key}] = #{value[:left]}
            +right[#{key}] = #{value[:right]}
          Q
          memo << line
        end
      end

      return lines.join("\n")
    end

    private

    def initialize(left, right)
      @left = left.to_hash
      @right = right.to_hash
    end

    def extra_report(memo, keys, value)
      if value.instance_of?(Hash)
        value.each_key do |key|
          extra_report(memo, keys + [key], value[key])
        end
      else
        path = keys.map { |key| "[#{key}]" }.join
        memo << "+left#{path} = #{value}"
      end
    end

    def missing_report(memo, keys, value)
      if value.instance_of?(Hash)
        value.each_key do |key|
          missing_report(memo, keys + [key], value[key])
        end
      else
        path = keys.map { |key| "[#{key}]" }.join
        memo << "-left#{path} = #{value}"
      end
    end

    def delta_report(memo, keys, value)
      if value.instance_of?(Hash) && value.keys != %i[left right]
        value.each_key do |key|
          delta_report(memo, keys + [key], value[key])
        end
      elsif value.instance_of?(Array) && value.size == 3 && value.all? { |el| el.instance_of?(Hash) }
        # [{}, {}, {:i=>:i}]
        extra_report(memo, keys, value[0]) unless value[0].empty?
        delta_report(memo, keys, value[1]) unless value[1].empty?
        missing_report(memo, keys, value[2]) unless value[2].empty?
      else
        path = keys.map { |key| "[#{key}]" }.join
        line = <<~Q
          -left#{path} = #{value[:left]}
          +right#{path} = #{value[:right]}
        Q
        memo << line
      end
    end

    def deep_delta(&block)
      result = delta(&block)

      result.keys.each_with_object({}) do |key, memo|
        if left[key].instance_of?(Hash) && right[key].instance_of?(Hash)
          memo[key] = self.class.new(left[key], right[key]).diff
        else
          memo[key] = result[key]
        end
      end
    end

    def first_level_delta(&block)
      [
        left_delta,
        delta(&block),
        right_delta
      ]
    end

    def right_delta
      right_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = right[key]
      end
    end

    def delta(&block)
      block ||= ->(val) { val }

      common_keys.each_with_object({}) do |key, memo|
        value_left = block.call(left[key])
        value_right = block.call(right[key])

        next if value_right.instance_of?(value_left.class) && (value_right == value_left)

        memo[key] = {
          left: value_left,
          right: value_right
        }
      end
    end

    def left_delta
      left_diff_keys.each_with_object({}) do |key, memo|
        memo[key] = left[key]
      end
    end

    def one_level_deep?
      left.values.none? { |value| value.respond_to?(:to_hash) } ||
        right.values.none? { |value| value.respond_to?(:to_hash) }
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
