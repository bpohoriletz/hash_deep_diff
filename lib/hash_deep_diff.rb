# frozen_string_literal: true

require 'hash_deep_diff/version'
require 'hash_deep_diff/delta/left'
require 'hash_deep_diff/delta/right'
require 'hash_deep_diff/comparison'

module HashDeepDiff
  class Error < StandardError; end
end
