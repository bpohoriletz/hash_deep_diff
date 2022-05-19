# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # factories
  module Factories
    # Factory for {HashDeepDiff::Comparison}
    class Comparison
      extend Forwardable

      def_delegators :delta, :left, :right, :change_key, :complex?, :complex_left?, :complex_right?

      # factory function
      # @return [HashDeepDiff::Comparison]
      def comparison(delta:, modifier: :change)
        @delta = delta

        fragments(modifier).map do |(left, right, change_key)|
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

      # entities for further comparison
      # @return [Array]
      def fragments(mode)
        case mode
        when :change
          return [[value_left, value_right, change_key]] unless complex?

          [[value_left, value_right, change_key + [ChangeKey::ARRAY_VALUE]],
           [nesting_left, nesting_right, change_key + [ChangeKey::NESTED_HASH]]]
        when :deletion
          [[value_left, NO_VALUE, change_key]]
        when :addition
          [[NO_VALUE, value_right, change_key]]
        end
      end

      # original value without nested hashes
      # @return [Object]
      def value_left
        return NO_VALUE if left.respond_to?(:to_hash) && right.respond_to?(:to_ary)
        return left unless left.respond_to?(:to_ary)

        left.reject { |el| el.respond_to?(:to_hash) }
      end

      # changed value without nested hashes
      # @return [Object]
      def value_right
        return NO_VALUE if right.respond_to?(:to_hash) && left.respond_to?(:to_ary)
        return right unless right.respond_to?(:to_ary)

        right.reject { |el| el.respond_to?(:to_hash) }
      end

      # nested hashes from original value
      # @return [Array<Hash>]
      def nesting_left
        return left if left.respond_to?(:to_hash)
        return NO_VALUE unless complex_left?

        left
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end

      # nested hashes from changed value
      # @return [Array<Hash>]
      def nesting_right
        return right if right.respond_to?(:to_hash)
        return NO_VALUE unless complex_right?

        right
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end
    end
  end
end
