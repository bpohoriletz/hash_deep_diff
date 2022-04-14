# frozen_string_literal: true

require 'hash_deep_diff/version'
require 'hash_deep_diff/comparison'

module HashDeepDiff
  NO_VALUE = Class.new(NilClass)
  class Error < StandardError; end
end
