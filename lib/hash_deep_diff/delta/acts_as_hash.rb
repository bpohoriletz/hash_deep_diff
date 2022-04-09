# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  module Delta
    module ActsAsHash
      def self.included(base)
        base.extend(Forwardable)
        base.def_delegators :@delta, :to_s, :inspect, :==, :each_with_object, :each_key, :[], :to_a, :empty?

        base.include(InstanceMethods)
      end

      module InstanceMethods
        def to_h
          delta
        end

        def to_hash
          delta
        end
      end
    end
  end
end
