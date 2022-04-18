# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # This module includes behavior that is needed to use instances of Delta instead of Hash
  # in this gem
  module ActsAsHash
    # @param [Object] base a hook that is invoked when module is included in a class
    def self.included(base)
      base.extend Forwardable
      base.def_delegators :@delta, :==, :each_with_object, :each_key, :[],
                          :to_a, :empty?, :keys
      base.include InstanceMethods
    end

    # We assume that the class will initialize instance variable +@delta+ that will return
    # a representation of an instance of a class as a +Hash+ object
    module InstanceMethods
      # a +Hash+ representation of an object
      def to_h
        to_hash
      end

      # a +Hash+ representation of an object
      def to_hash
        @delta
      end
    end
  end
end
