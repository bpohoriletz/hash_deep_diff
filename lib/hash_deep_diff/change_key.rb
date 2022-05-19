# frozen_string_literal: true

require 'forwardable'

module HashDeepDiff
  # Key for a compared value inside Array or Hash
  class ChangeKey
    extend Forwardable
    def_delegators :to_ary, :[], :+, :map, :==, :first, :shift, :empty?
    # element that indicates nested Hash
    NESTED_HASH = '{}'
    # element that indicates Array value
    ARRAY_VALUE = '...'

    # based on the first element of the key returns the initial object
    # to buld the change representation
    # @return [Array, Hash]
    def self.initial_object(values:)
      if values.size.positive? && [NESTED_HASH, ARRAY_VALUE].include?(values.first[0].first)
        []
      else
        {}
      end
    end

    # set the value inside Hash based on the change_key
    # @return [Array, Hash]
    # TOFIX; check if @path are mutated
    def set(obj, value, clone_keys = path.clone)
      current_key = clone_keys.shift
      set_initial_value(current_key, obj, clone_keys)
      set_value(current_key, obj, value, clone_keys)
      prepare_nesting(current_key, obj, clone_keys)
      recursive_set(current_key, obj, value, clone_keys)

      return obj
    end

    # see {#to_ary}
    # @return [Array]
    def to_a
      to_ary
    end

    # array with keysused to initialize the object
    # @return [Array]
    def to_ary
      path
    end

    # see {#to_str}
    # @return [String]
    def to_s
      to_str
    end

    # visual representation of the change key
    # @return [String]
    def to_str
      path.map { |key| "[#{key}]" }.join
    end

    private

    attr_reader :path

    def initialize(path:)
      @path = path.to_ary
    end

    def set_initial_value(current_key, obj, clone_keys)
      if NESTED_HASH == current_key
        obj << {} unless obj[-1].respond_to?(:to_hash)
      elsif [ARRAY_VALUE] == clone_keys
        obj[current_key] ||= []
      elsif NESTED_HASH == clone_keys[0]
        obj[current_key] ||= []
        obj[current_key] << {} unless obj[current_key][-1].respond_to?(:to_hash)
      elsif !clone_keys.empty? && ARRAY_VALUE != current_key
        obj[current_key] ||= {}
      end
    end

    def set_value(current_key, obj, value, clone_keys)
      if ARRAY_VALUE == current_key
        obj.prepend(*value)
        clone_keys.pop
      elsif clone_keys.empty? && obj.respond_to?(:to_hash)
        obj[current_key] = value
        clone_keys.pop
      elsif [ARRAY_VALUE] == clone_keys
        obj[current_key] ||= []
        obj[current_key] = value + obj[current_key]
        clone_keys.pop
      end
    end

    def prepare_nesting(current_key, obj, clone_keys)
      if NESTED_HASH == current_key
        obj << {} unless obj[-1].respond_to?(:to_hash)
      elsif NESTED_HASH == clone_keys[0]
        obj[current_key] << {} unless obj[current_key][-1].respond_to?(:to_hash)
      end
    end

    def recursive_set(current_key, obj, value, clone_keys)
      if NESTED_HASH == current_key
        set(obj[-1], value, clone_keys)
      elsif NESTED_HASH == clone_keys[0]
        set(obj[current_key][-1], value, clone_keys[1..])
      elsif !clone_keys.empty?
        set(obj[current_key], value, clone_keys)
      end
    end
  end
end
