# frozen_string_literal: true

require_relative 'base'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff < Base
      private

      # line of the report with deleted value
      # @return [String]
      def original
        return '' if old_val == NO_VALUE
        return "#{deletion}#{path} = #{old_val}\n" unless array_to_array?
        return '' if array_deletion.empty?

        "#{deletion}#{path} = #{array_deletion}\n"
      end

      # line of the report with added value
      # @return [String]
      def replacement
        return '' if new_val == NO_VALUE
        return "#{addition}#{path} = #{new_val}\n" unless array_to_array?
        return '' if array_addition.empty?

        "#{addition}#{path} = #{array_addition}\n"
      end

      # returns true if original value and replacement are instances of +Array+
      # @return Bool
      def array_to_array?
        old_val.instance_of?(Array) && new_val.instance_of?(Array)
      end

      # added elemnts of array
      # @return [Array]
      def array_addition
        new_val - old_val
      end

      # added elemnts of array
      # @return [Array]
      def array_deletion
        old_val - new_val
      end

      # Visual representation of keys from compared objects needed to fetch the compared values
      # @return [String]
      def path
        change_key.map { |key| "[#{key}]" }.join
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
