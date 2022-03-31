# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff' do
    it 'returns an empty hash if left quals right' do
      left = { a: :b }
      right = { a: :b }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, {}], diff)
    end

    it 'returns left if right is empty' do
      left = { a: :b }
      right = {}

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([left, {}, {}], diff)
    end

    it 'returns right if left is empty' do
      left = {}
      right = { c: :d }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, right], diff)
    end

    it 'returns difference for one-level deep hash with string values' do
      left = { a: 'b', c: 'd', e: 'f' }
      right = { c: 'd', e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, { a: 'b' }], diff)
    end
  end
end
