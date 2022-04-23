# frozen_string_literal: true

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff
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

      attr_reader :old_val, :new_val, :path

      # @param [Delta] delta diff to report
      def initialize(delta:)
        @path = delta.path.to_ary
        @old_val = delta.left
        @new_val = delta.right
      end

      # old value
      # @return [String]
      def original
        return '' if old_val == NO_VALUE

        return "#{deletion_prefix}#{diff_prefix} = #{old_val}\n"
      end

      # new value
      # @return [String]
      def replacement
        return '' if new_val == NO_VALUE

        return "#{addition}#{diff_prefix} = #{new_val}\n"
      end

      # Visual representation of keys from compared objects needed to fetch the compared values
      # @return [String]
      def diff_prefix
        path.map { |key| "[#{key}]" }.join
      end

      # visual indication of addition
      # @return [String]
      def addition
        '+left'
      end

      # visual indication of deletion
      # @return [String]
      def deletion_prefix
        '-left'
      end
    end
  end
end
