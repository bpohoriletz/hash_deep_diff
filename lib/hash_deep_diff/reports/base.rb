# frozen_string_literal: true

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Abstract Class
    class Base
      # see {#to_str}
      # @return [String]
      def to_s
        to_str
      end

      # A report on additions and deletions
      # @return [String]
      def to_str
        original + replacement
      end

      private

      # @!attribute [r] old_val
      #    @return [Object] original value
      # @!attribute [r] new_val
      #    @return [Object] replacement of the original value
      # @!attribute [r] change_key
      #    @return [Array<Object>] subset of keys from original Hashes to fetch reported values
      #    (is empty for top-level comparison)
      attr_reader :old_val, :new_val, :change_key

      # @param [Delta] delta diff to report
      def initialize(delta:)
        @change_key = delta.change_key.to_ary
        @old_val = delta.left
        @new_val = delta.right
      end

      # old value
      def original
        raise AbstractMethodError
      end

      # new value
      def replacement
        raise AbstractMethodError
      end
    end
  end
end
