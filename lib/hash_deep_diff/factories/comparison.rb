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

        chunks(modifier).map do |(left, right, change_key)|
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

          if complex_left? && complex_right?
            [
              [left_array, right_array, change_key + ['...']],
              [left_hashes, right_hashes, change_key + ['{}']]
            ]
          elsif complex_right?
            if left.respond_to?(:to_hash)
              [
                [NO_VALUE, right_array, change_key + ['...']],
                [NO_VALUE, right_hashes, change_key + ['{}']],
                [left, NO_VALUE, change_key]
              ]
            else
              [
                [left, right_array, change_key + ['...']],
                [NO_VALUE, right_hashes, change_key + ['{}']]
              ]
            end
          elsif right.respond_to?(:to_hash)
            [
              [left_array, NO_VALUE, change_key + ['...']],
              [left_hashes, NO_VALUE, change_key + ['{}']],
              [NO_VALUE, right, change_key]
            ]
          else
            [
              [left_array, right, change_key + ['...']],
              [left_hashes, NO_VALUE, change_key + ['{}']]
            ]
          end
        when :deletion
          [[left, NO_VALUE, change_key]]
        when :addition
          [[NO_VALUE, right, change_key]]
        else
          raise Error, 'Unknown modifier'
        end
      end

      def left_array
        left.reject { |el| el.respond_to?(:to_hash) }
      end

      def right_array
        right.reject { |el| el.respond_to?(:to_hash) }
      end

      def left_hashes
        left
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end

      def right_hashes
        right
          .select { |el| el.respond_to?(:to_hash) }
          .each_with_object({}) { |el, memo| memo.merge!(el) }
      end
    end
  end
end
