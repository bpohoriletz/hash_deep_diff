# frozen_string_literal: true

module HashDeepDiff
  # factories
  module Factories
    # Factory for {HashDeepDiff::Comparison}
    class Comparison
      # factory function
      # @return [HashDeepDiff::Comparison]
      def comparison(delta:, modifier: :change)
        # chunks.map do |(left, right, change_key)|
        # HashDeepDiff::Comparison.new(left, right, change_key,
        # delta_engine: delta.class,
        # reporting_engine: reporting_engine)
        # end
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
        if delta.complex?
          # if left array with hashes
          # if right array with hases
          # else hashes
          if delta.complex_left? && delta.complex_right?
            left_array = delta.left.reject { |e| e.respond_to?(:to_hash) }
            right_array = delta.right.reject { |e| e.respond_to?(:to_hash) }
            left_hashes = delta.left.select do |e|
                            e.respond_to?(:to_hash)
                          end.each_with_object({}) { |e, memo| memo.merge!(e) }
            right_hashes = delta.right.select do |e|
                             e.respond_to?(:to_hash)
                           end.each_with_object({}) { |e, memo| memo.merge!(e) }
            [
              HashDeepDiff::Comparison.new(left_array, right_array, delta.change_key + ['...'],
                                           delta_engine: delta.class,
                                           reporting_engine: reporting_engine),
              HashDeepDiff::Comparison.new(left_hashes, right_hashes, delta.change_key + ['{}'],
                                           delta_engine: delta.class,
                                           reporting_engine: reporting_engine)
            ]
          elsif delta.complex_right?
            right_array = delta.right.reject { |e| e.respond_to?(:to_hash) }
            right_hashes = delta.right.select do |e|
                             e.respond_to?(:to_hash)
                           end.each_with_object({}) { |e, memo| memo.merge!(e) }
            if delta.left.respond_to?(:to_hash)
              [
                HashDeepDiff::Comparison.new(NO_VALUE, right_array, delta.change_key + ['...'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(NO_VALUE, right_hashes, delta.change_key + ['{}'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(delta.left, NO_VALUE, delta.change_key,
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine)
              ]
            else
              [
                HashDeepDiff::Comparison.new(delta.left, right_array, delta.change_key + ['...'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(NO_VALUE, right_hashes, delta.change_key + ['{}'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine)
              ]
            end
          else
            left_array = delta.left.reject { |e| e.respond_to?(:to_hash) }
            left_hashes = delta.left.select do |e|
                            e.respond_to?(:to_hash)
                          end.each_with_object({}) { |e, memo| memo.merge!(e) }
            if delta.right.respond_to?(:to_hash)
              [
                HashDeepDiff::Comparison.new(left_array, NO_VALUE, delta.change_key + ['...'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(left_hashes, NO_VALUE, delta.change_key + ['{}'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(NO_VALUE, delta.right, delta.change_key,
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine)
              ]
            else
              [
                HashDeepDiff::Comparison.new(left_array, delta.right, delta.change_key + ['...'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine),
                HashDeepDiff::Comparison.new(left_hashes, NO_VALUE, delta.change_key + ['{}'],
                                             delta_engine: delta.class,
                                             reporting_engine: reporting_engine)
              ]
            end
          end
        else
          [
            HashDeepDiff::Comparison.new(delta.left, delta.right, delta.change_key,
                                         delta_engine: delta.class,
                                         reporting_engine: reporting_engine)
          ]
        end
      end

      # compare Hash with nothing (deletion)
      # @return [HashDeepDiff::Comparison]
      def compare_original_no_nothing(delta)
        [
          HashDeepDiff::Comparison.new(delta.left, NO_VALUE, delta.change_key,
                                       delta_engine: delta.class,
                                       reporting_engine: reporting_engine)
        ]
      end

      # compare nothing with Hash (addition)
      # @return [HashDeepDiff::Comparison]
      def compare_nothing_to_changed(delta)
        [
          HashDeepDiff::Comparison.new(NO_VALUE, delta.right, delta.change_key,
                                       delta_engine: delta.class,
                                       reporting_engine: reporting_engine)
        ]
      end
    end
  end
end
