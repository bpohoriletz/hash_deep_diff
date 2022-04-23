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

      attr_reader :old_val, :new_val, :change_key

      # @param [Delta] delta diff to report
      def initialize(delta:)
        @change_key = delta.path.to_ary
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
