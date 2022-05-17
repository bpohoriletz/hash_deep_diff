# frozen_string_literal: true

require_relative 'base'
require 'forwardable'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Yml < Base
      extend Forwardable
      def_delegators :@change_key, :initial_object, :dig_set

      # additions and deletions represented as YAML
      # @return [String]
      def report
        YAML.dump(raw_report)
      end

      # additions and deletiond represented as Hash
      # @return [Hash]
      def raw_report
        @raw = { additions: initial_object(values: additions), deletions: initial_object(values: deletions) }

        additions.each { |(change_key, addition)| dig_set(raw[:additions], change_key, addition) }
        deletions.each { |(change_key, deletion)| dig_set(raw[:deletions], change_key, deletion) }

        return raw
      end

      private

      attr_reader :raw

      # added values
      # @return [Array<HashDeepDiff::Delta>]
      def additions
        diff.reject { |delta| delta.right == NO_VALUE }
            .map { |delta| [delta.change_key.dup, delta.addition] }
            .reject { |(_, addition)| [] == addition }
      end

      # deleted values
      # @return [Array<HashDeepDiff::Delta>]
      def deletions
        diff.reject { |delta| delta.left == NO_VALUE }
            .map { |delta| [delta.change_key.dup, delta.deletion] }
            .reject { |(_, deletion)| [] == deletion }
      end
    end
  end
end
