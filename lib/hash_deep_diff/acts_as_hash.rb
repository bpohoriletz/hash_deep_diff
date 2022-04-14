# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # This module includes behavior that is needed to use deltas instead of Hash inside this gem
  module ActsAsHash
    def self.included(base)
      base.include(InstanceMethods)
      base.extend(Forwardable)
      base.def_delegators :@delta, :==, :each_with_object, :each_key, :[],
                          :to_a, :empty?, :keys
    end

    # Assumes that the class will include method delta that will return a representation of an
    # instance of a class as a Hash
    module InstanceMethods
      def to_h
        @delta
      end

      def to_hash
        @delta
      end
    end
  end
end
