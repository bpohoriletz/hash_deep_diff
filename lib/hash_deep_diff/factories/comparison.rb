# frozen_string_literal: true

module HashDeepDiff
  # factories
  module Factories
    # Factory for {HashDeepDiff::Comparison}
    class Comparison
      # factory function
      # @return [HashDeepDiff::Comparison]
      def comparison(delta:, modifier: :change)
        case modifier
        when :change
          inward_comparison(delta)
        when :deletion
          compare_original_no_nothing(delta)
        when :addition
          compare_nothing_to_changed(delta)
        else
          raise Error, 'Unknown modifier'
        end
      end

      private

      # @!attribute [r] reporting_engine
      #    @return [HashDeepDiff::Reports::Base] descendant of
      # @!attribute [r] delta
      #    @return [HashDeepDiff::Delta]
      attr_reader :reporting_engine, :delta

      def initialize(reporting_engine:)
        @reporting_engine = reporting_engine
      end

      # compare two hashes
      # @return [HashDeepDiff::Comparison]
      def inward_comparison(delta)
        HashDeepDiff::Comparison.new(delta.left, delta.right, delta.change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare Hash with nothing (deletion)
      # @return [HashDeepDiff::Comparison]
      def compare_original_no_nothing(delta)
        HashDeepDiff::Comparison.new(delta.left, NO_VALUE, delta.change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare nothing with Hash (addition)
      # @return [HashDeepDiff::Comparison]
      def compare_nothing_to_changed(delta)
        HashDeepDiff::Comparison.new(NO_VALUE, delta.right, delta.change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end
    end
  end
end
