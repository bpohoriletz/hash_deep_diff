# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
require 'pry'
require 'hash_deep_diff'
require_relative 'support/fixture'

Minitest::Reporters.use!
