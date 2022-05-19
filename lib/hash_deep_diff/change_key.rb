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
      if NESTED_HASH == current_key
        obj << {} unless obj[-1].respond_to?(:to_hash)
        set(obj[-1], value, clone_keys)
      elsif ARRAY_VALUE == current_key
        obj.prepend(*value)
      elsif clone_keys.empty?
        obj[current_key] = value
      elsif [ARRAY_VALUE] == clone_keys
        obj[current_key] ||= []
        obj[current_key] = value + obj[current_key]
      elsif NESTED_HASH == clone_keys[0]
        set_nested_hash(obj, current_key, clone_keys)
        set(obj[current_key][-1], value, clone_keys)
      else
        obj[current_key] ||= {}
        set(obj[current_key], value, clone_keys)
      end

      return obj
    end

    # TOFIX; Introduce change key object
    def set_nested_hash(obj, key, clone_keys)
      clone_keys.shift
      obj[key] ||= []
      obj[key] << {} unless obj[key][-1].respond_to?(:to_hash)
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
  end
end
