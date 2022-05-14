# frozen_string_literal: true

require_relative 'base'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Yml < Base
      # additions and deletions represented as YAML
      # @return [String]
      def report
        # YAML.dump(raw_report)
      end

      # additions and deletiond represented as Hash
      # @return [Hash]
      def raw_report
        @raw = { additions: {}, deletions: {} }

        additions.each { |(change_key, addition)| dig_set(raw[:additions], change_key, addition) }
        deletions.each { |(change_key, deletion)| dig_set(raw[:deletions], change_key, deletion) }

        return raw
      end

      private

      attr_reader :raw

      # @return [Array<HashDeepDiff::Delta>]
      def additions
        diff.reject { |delta| delta.right == NO_VALUE }
            .map { |delta| [delta.change_key.dup, delta.addition] }
      end

      # @return [Array<HashDeepDiff::Delta>]
      def deletions
        diff.reject { |delta| delta.left == NO_VALUE }
            .map { |delta| [delta.change_key.dup, delta.deletion] }
      end

      # set the value inside Hash based on the change_key
      def dig_set(obj, keys, value)
        key = keys.shift
        if keys.empty?
          obj[key] = value
        elsif ['...'] == keys
          obj[key] ||= []
          obj[key] = value + obj[key]
        elsif '{}' == keys[0]
          set_nested_hash(obj, key, keys)
          dig_set(obj[key][-1], keys, value)
        else
          obj[key] ||= {}
          dig_set(obj[key], keys, value)
        end
      end

      # TOFIX; Introduce change key object
      def set_nested_hash(obj, key, keys)
        keys.shift
        obj[key] ||= []
        obj[key] << {} unless obj[key][-1].respond_to?(:to_hash)
      end
    end
  end
end
