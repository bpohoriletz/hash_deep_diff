# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  module Delta
    # This module includes behavior that is needed to use deltas instead of Hash inside this gem
    module ActsAsDelta
      def self.included(base)
        base.prepend(Initialize)
        base.include(InstanceMethods)
        base.extend(Forwardable)
        base.def_delegators :@delta, :inspect, :==, :each_with_object, :each_key, :[],
                            :to_a, :empty?, :keys
      end

      # Assumes that the class will include method delta that will return a representation of an
      # instance of a class as a Hash
      module InstanceMethods
        def path
          full_path = @prefix + [@delta.keys.first]

          full_path.map { |key| "[#{key}]" }.join
        end

        def to_h
          @delta
        end

        def to_hash
          @delta
        end

        def to_s
          to_str
        end

        def to_str
          raise NoMethodError, "expected #{self.class} to implement #to_str"
        end
      end

      # Override #initialize method
      module Initialize
        def initialize(path:, value:)
          # TOFIX this may prohibit usage of hashes with Array keys
          if path.respond_to?(:to_ary)
            @delta = { path[-1] => value }
            @prefix = path[0..-2]
          else
            @delta = { path => value }
            @prefix = []
          end
        end
      end
    end
  end
end
