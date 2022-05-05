# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # factories
  module Factories
    # Factory for {HashDeepDiff::Comparison}
    class Comparison
      extend Forwardable

      def_delegators :@delta, :left, :right, :change_key, :complex?, :complex_left?, :complex_right?

      # factory function
      # @return [HashDeepDiff::Comparison]
      def comparison(delta:, modifier: :change)
        @delta = delta

        chunks(modifier).compact.map do |(left, right, change_key)|
          HashDeepDiff::Comparison.new(left, right, change_key,
                                       delta_engine: delta.class,
                                       reporting_engine: reporting_engine)
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

      # @return [Array]
      def chunks(mode)
        case mode
        when :change
          return [[left, right, change_key]] unless complex?

          [[left_array, right_array, change_key + ['...']],
           [left_hashes, right_hashes, change_key + ['{}']]]
        when :deletion
          [[left, NO_VALUE, change_key]]
        when :addition
          [[NO_VALUE, right, change_key]]
        end
      end

      # @return [Object]
      def left_array
        return left unless left.respond_to?(:to_ary)

        left.reject { |el| el.respond_to?(:to_hash) }
      end

      # @return [Object]
      def right_array
        return right unless right.respond_to?(:to_ary)

        right.reject { |el| el.respond_to?(:to_hash) }
      end

      # @return [Array<Hash>]
      def left_hashes
        return NO_VALUE unless complex_left?

        left
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end

      # @return [Array<Hash>]
      def right_hashes
        return NO_VALUE unless complex_right?

        right
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end
    end
  end
end
