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
      # @return [Comparison]
      def comparison(delta:, modifier: nil)
        @delta = delta

        case modifier
        when nil
          full_compare
        when :left
          compare_left
        when :right
          compare_right
        end
      end

      private

      attr_reader :reporting_engine, :delta

      def initialize(reporting_engine:)
        @reporting_engine = reporting_engine
      end

      # compare two hashes
      def full_compare
        HashDeepDiff::Comparison.new(left, right, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare Hash with nothing (deletion)
      def compare_left
        HashDeepDiff::Comparison.new(left, NO_VALUE, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end

      # compare nothing with Hash (addition)
      def compare_right
        HashDeepDiff::Comparison.new(NO_VALUE, right, change_key,
                                     delta_engine: delta.class,
                                     reporting_engine: reporting_engine)
      end
    end
  end
end
