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
        return "#{deletion}#{path} = #{old_val.sort - new_val.sort}\n" if array_with_array?

        return "#{deletion}#{path} = #{old_val}\n"
      end

      # line of the report with added value
      # @return [String]
      def replacement
        return '' if new_val == NO_VALUE
        return "#{addition}#{path} = #{new_val.sort - old_val.sort}\n" if array_with_array?

        return "#{addition}#{path} = #{new_val}\n"
      end

      # returns true if original value and replacement are instances of +Array+
      # @return Bool
      def array_with_array?
        old_val.instance_of?(Array) && new_val.instance_of?(Array)
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
