# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[TRIVIAL]HashDeepDiff::Comparison#diff' do
    it 'finds difference between small and empty hashes' do
      left, right = load_fixture('one_level/small', 'empty')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: { left: 'b', right: HashDeepDiff::NO_VALUE } }], diff)
    end

    it 'finds difference between empty and small hashes' do
      left, right = load_fixture('empty', 'one_level/small')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: { left: HashDeepDiff::NO_VALUE, right: 'b' } }], diff)
    end
  end

  describe '[TRIVIAL]HashDeepDiff::Comparison#report' do
    it 'visualizes difference between smal and empty hashes' do
      left, right = load_fixture('empty', 'one_level/small')

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal("+left[a] = b\n", report)
    end

    it 'visualizes difference between empty and small hashes' do
      left, right = load_fixture('one_level/small', 'empty')

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal("-left[a] = b\n", report)
    end
  end
end
