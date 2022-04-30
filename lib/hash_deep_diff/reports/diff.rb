# frozen_string_literal: true

require_relative 'base'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff < Base
      private

      # old value
      # @return [String]
      def original
        return '' if old_val == NO_VALUE
        return "#{deletion}#{path} = #{old_val}\n" if primitive?
        return "#{deletion}#{path} = #{old_val.sort - new_val.sort}\n" if array_to_array?

        raise Error, 'Unexpected Delta'
      end

      # new value
      # @return [String]
      def replacement
        return '' if new_val == NO_VALUE
        return "#{addition}#{path} = #{new_val}\n" if primitive?
        return "#{addition}#{path} = #{new_val.sort - old_val.sort}\n" if array_to_array?

        raise Error, 'Unexpected Delta'
      end

      # returns true if left, right or both are primitive
      # and there is no need to buld diff before reporting
      # @return Bool
      def primitive?
        !array_to_array?
      end

      def array_to_array?
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
