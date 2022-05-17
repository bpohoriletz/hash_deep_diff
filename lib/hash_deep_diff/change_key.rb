# frozen_string_literal: true

module HashDeepDiff
  # Key for a compared value inside Array or Hash
  class ChangeKey
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
    def self.dig_set(obj, keys, value)
      key = keys.shift
      if NESTED_HASH == key
        obj << {} unless obj[-1].respond_to?(:to_hash)
        dig_set(obj[-1], keys, value)
      elsif ARRAY_VALUE == key
        obj.prepend(*value)
      elsif keys.empty?
        obj[key] = value
      elsif [ARRAY_VALUE] == keys
        obj[key] ||= []
        obj[key] = value + obj[key]
      elsif NESTED_HASH == keys[0]
        set_nested_hash(obj, key, keys)
        dig_set(obj[key][-1], keys, value)
      else
        obj[key] ||= {}
        dig_set(obj[key], keys, value)
      end

      return obj
    end

    # TOFIX; Introduce change key object
    def self.set_nested_hash(obj, key, keys)
      keys.shift
      obj[key] ||= []
      obj[key] << {} unless obj[key][-1].respond_to?(:to_hash)
    end

    private

    attr_reader :key

    def initialize(key:)
      @key = key.to_ary
    end
  end
end
