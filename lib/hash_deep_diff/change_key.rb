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
      return [] if values.size.positive? && [NESTED_HASH, ARRAY_VALUE].include?(values[0][0][0])

      {}
    end

    # set the value inside Hash based on the change_key
    # @return [Array, Hash]
    # TOFIX; check if @path are mutated
    def set(obj, value, clone_keys = path.clone)
      # 1. Fetch key
      current_key = clone_keys.shift
      # 2. Prepare object for further processing
      init_value(current_key, obj, clone_keys)
      init_nesting(current_key, obj, clone_keys)
      # 3. Set value - directly or recursively
      set_value(current_key, obj, value, clone_keys)
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

    # prepare an object before further processing
    def init_value(current_key, obj, clone_keys)
      if [ARRAY_VALUE] == clone_keys || NESTED_HASH == clone_keys.first
        obj[current_key] ||= []
      elsif !clone_keys.empty? && ![ARRAY_VALUE, NESTED_HASH].include?(current_key)
        obj[current_key] ||= {}
      end
    end

    # prepare nesting before further processing
    def init_nesting(current_key, obj, clone_keys)
      element = if NESTED_HASH == current_key
                  obj
                elsif NESTED_HASH == clone_keys.first
                  obj[current_key]
                end
      element << {} unless element.nil? || element.last.respond_to?(:to_hash)
    end

    # no more nesting - set value inside object
    def set_value(current_key, obj, value, clone_keys)
      if ARRAY_VALUE == current_key
        obj.prepend(*value)
        clone_keys.pop
      elsif clone_keys.empty?
        obj[current_key] = value
        clone_keys.pop
      elsif [ARRAY_VALUE] == clone_keys
        obj[current_key] = value + obj[current_key]
        clone_keys.pop
      end
    end

    # recursion for deeply nested values
    def recursive_set(current_key, obj, value, clone_keys)
      if NESTED_HASH == current_key
        set(obj.last, value, clone_keys)
      elsif NESTED_HASH == clone_keys.first
        set(obj[current_key].last, value, clone_keys[1..])
      elsif !clone_keys.empty?
        set(obj[current_key], value, clone_keys)
      end
    end
  end
end
