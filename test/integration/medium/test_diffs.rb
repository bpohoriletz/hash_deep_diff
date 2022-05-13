# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[MEDIUM]HashDeepDiff::Comparison#diff' do
    it 'finds elements that differ' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right[:b] = { c: 'd' }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(
        [{ c: { left: 'c', right: 'd' } }, { d: { left: 'd', right: HashDeepDiff::NO_VALUE } }], diff
      )
      assert_equal([%i[b c], %i[b d]], diff.map(&:change_key))
    end

    it 'finds elements that differ' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right[:b] = { c: 'd', e: 3 }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(
        [{ c: { left: 'c', right: 'd' } }, { d: { left: 'd', right: HashDeepDiff::NO_VALUE } },
         { e: { left: HashDeepDiff::NO_VALUE, right: 3 } }], diff
      )
      assert_equal([%i[b c], %i[b d], %i[b e]], diff.map(&:change_key))
    end
  end
end
