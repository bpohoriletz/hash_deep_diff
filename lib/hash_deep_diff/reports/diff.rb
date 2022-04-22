# frozen_string_literal: true

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff
      # We have two cases
      #   * added - when value on the left is missing
      #   * deleted - when the value on the right is missing
      module Mode
        # for additions
        ADDITION = '+left'
        # for deletions
        DELETION = '-left'
      end

      # see {#to_str}
      # @return [String]
      def to_s
        to_str
      end

      # A report on additions and deletions
      # @return [String]
      def to_str
        addition + deletion
      end

      # @return [String]
      def addition
        return '' if old_val == NO_VALUE

        return [Mode::DELETION, diff_prefix, ' = ', old_val.to_s, "\n"].join
      end

      # @return [String]
      def deletion
        return '' if new_val == NO_VALUE

        return [Mode::ADDITION, diff_prefix, ' = ', new_val.to_s, "\n"].join
      end

      private

      attr_reader :old_val, :new_val

      # @param [Delta] delta diff to report
      def initialize(delta:)
        @path = delta.path.to_ary
        @old_val = delta.left
        @new_val = delta.right
      end

      # Visual representation of keys from compared objects needed to fetch the compared values
      # @return [String]
      def diff_prefix
        # TOFIX poor naming
        @path.map { |key| "[#{key}]" }.join
      end
    end
  end
end
