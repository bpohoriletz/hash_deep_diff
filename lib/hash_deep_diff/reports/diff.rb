# frozen_string_literal: true

require_relative 'base'

module HashDeepDiff
  # Different reporting enjines for {Delta}
  module Reports
    # Visual representation of the {Delta} as diff
    class Diff < Base
      private

      # old value
      # @return [String]
      def original
        return '' if old_val == NO_VALUE

        return "#{deletion}#{fetch_path} = #{old_val}\n"
      end

      # new value
      # @return [String]
      def replacement
        return '' if new_val == NO_VALUE

        return "#{addition}#{fetch_path} = #{new_val}\n"
      end

      # Visual representation of keys from compared objects needed to fetch the compared values
      # @return [String]
      def fetch_path
        path.map { |key| "[#{key}]" }.join
      end

      # visual indication of addition
      # @return [String]
      def addition
        '+left'
      end

      # visual indication of deletion
      # @return [String]
      def deletion
        '-left'
      end
    end
  end
end
