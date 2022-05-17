# frozen_string_literal: true

require 'hash_deep_diff/version'
require 'hash_deep_diff/reports/diff'
require 'hash_deep_diff/reports/yml'
require 'hash_deep_diff/delta'
require 'hash_deep_diff/change_key'
require 'hash_deep_diff/comparison'

# Global namespace
module HashDeepDiff
  # value was not found
  NO_VALUE = Class.new(NilClass)
  # Abstract method
  AbstractMethodError = Class.new(NoMethodError)
  # Any error
  Error = Class.new(StandardError)
end
