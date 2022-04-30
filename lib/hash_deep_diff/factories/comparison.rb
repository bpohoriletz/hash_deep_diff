# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # factories
  module Factories
    # Factory for {HashDeepDiff::Comparison}
    class Comparison
      extend Forwardable
      def_delegators :delta, :left, :right, :change_key

      # factory function
      # @return [HashDeepDiff::Comparison]
      def comparison(delta:, modifier: nil)
        @delta = delta

        case modifier
        when nil
          inward_comparison
        when :deletion
          compare_original_no_nothing
        when :addition
          compare_changed_to_nothing
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
      def inward_comparison
        HashDeepDiff::Comparison.new(left, right, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare Hash with nothing (deletion)
      # @return [HashDeepDiff::Comparison]
      def compare_original_no_nothing
        HashDeepDiff::Comparison.new(left, NO_VALUE, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare nothing with Hash (addition)
      # @return [HashDeepDiff::Comparison]
      def compare_changed_to_nothing
        HashDeepDiff::Comparison.new(NO_VALUE, right, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end
    end
  end
end
