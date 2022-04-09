# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  module Delta
    # This module includes behavior that is needed to use deltas instead of Hash inside this gem
    module ActsAsHash
      def self.included(base)
        base.extend(Forwardable)
        base.def_delegators :@delta, :to_s, :inspect, :==, :each_with_object, :each_key, :[],
          :to_a, :empty?, :keys

        base.include(InstanceMethods)
      end

      # Assumes that the class will include method delta that will return a representation of an
      # instance of a class as a Hash
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
