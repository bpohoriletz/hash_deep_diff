# frozen_string_literal: true

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Abstract Class
    class Base
      # raw data for {#report}
      def raw_report
        raise AbstractMethodError
      end

      # see {#to_str}
      # @return [String]
      def to_s
        to_str
      end

      # see {#report}
      # @return [String]
      def to_str
        report
      end

      # A report on additions and deletions
      # @return [String]
      def report
        raise AbstractMethodError
      end

      private

      # @!attribute [r] diff
      #    @return [Array<HashDeepDiff::Delta>] set of deltas from Comparison of two objects
      attr_reader :diff

      # @param [Array<HashDeepDiff::Delta>] diff comparison data to report
      def initialize(diff:)
        @diff = diff.to_ary
      end
    end
  end
end
