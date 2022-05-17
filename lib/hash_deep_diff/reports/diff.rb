# frozen_string_literal: true

require_relative 'base'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff < Base
      # additiond and deletions represented as diff
      # @return [String]
      def report
        raw_report.map { |delta| original(delta) + replacement(delta) }.join
      end

      # additiond and deletions raw
      # @return [Array<HashDeepDiff::Delta>]
      def raw_report
        diff
      end

      private

      # line of the report with deleted value
      # @return [String]
      def original(delta)
        return '' if delta.left == NO_VALUE
        return "#{deletion}#{delta.change_key} = #{delta.left}\n" unless array_to_array?(delta)
        return '' if array_deletion(delta).empty?

        "#{deletion}#{delta.change_key} = #{array_deletion(delta)}\n"
      end

      # line of the report with added value
      # @return [String]
      def replacement(delta)
        return '' if delta.right == NO_VALUE
        return "#{addition}#{delta.change_key} = #{delta.right}\n" unless array_to_array?(delta)
        return '' if array_addition(delta).empty?

        "#{addition}#{delta.change_key} = #{array_addition(delta)}\n"
      end

      # returns true if original value and replacement are instances of +Array+
      # @return Bool
      # TOFIX drop
      def array_to_array?(delta)
        delta.left.instance_of?(Array) && delta.right.instance_of?(Array)
      end

      # added elemnts of array
      # @return [Array]
      def array_addition(delta)
        delta.right - delta.left
      end

      # added elemnts of array
      # @return [Array]
      def array_deletion(delta)
        delta.left - delta.right
      end

      # visual indication of addition
      # @return [String]
      def addition
        '+left'
      end

      # visual indication of deletion
      # @return [String]
      def deletion
        '-left'
      end
    end
  end
end
