# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/reporters'
require 'minitest/spec'

require 'pry'
require 'hash_deep_diff'
require_relative 'support/fixture'
require_relative 'support/extensions'

Minitest::Test.include(Support::Extensions)
Minitest::Reporters.use!
