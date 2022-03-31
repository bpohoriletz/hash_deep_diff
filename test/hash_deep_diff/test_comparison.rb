# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff' do
    it 'returns an empty hash if left quals right' do
      left = { a: :b }
      right = { a: :b }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_empty(diff)
    end

    it 'returns left if right is empty' do
      left = { a: :b }
      right = {}

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(left, diff)
    end

    it 'returns right if left is empty' do
      left = {}
      right = { c: :d }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(right, diff)
    end
  end
end
