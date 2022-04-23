# frozen_string_literal: true

require 'hash_deep_diff/version'
require 'hash_deep_diff/reports/diff'
require 'hash_deep_diff/comparison'

# Global namespace
module HashDeepDiff
  # value was not found
  NO_VALUE = Class.new(NilClass)
  AbstractMethodError = Class.new(NoMethodError)
end
