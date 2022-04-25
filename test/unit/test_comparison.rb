# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  let(:spy) { Naught.build }

  describe '#diff' do
    it 'returns an empty Array if empty hashes are compared' do
      diff = HashDeepDiff::Comparison.new({}, {}, delta_engine: spy, reporting_engine: spy).diff

      assert_empty(diff)
    end

    it 'returns an empty Array if values are equal' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      diff = HashDeepDiff::Comparison.new(left, right, delta_engine: spy, reporting_engine: spy).diff

      assert_empty(diff)
    end

    it 'finds elments that differ for small and empty Hash' do
      left, right = load_fixture('one_level/small', 'empty')
      diff = HashDeepDiff::Comparison.new(left, right, delta_engine: spy, reporting_engine: spy).diff

      assert_equal(1, diff.size)
    end

    it 'finds elments that differ for empty and small Hash' do
      left, right = load_fixture('empty', 'one_level/small')
      diff = HashDeepDiff::Comparison.new(left, right, delta_engine: spy, reporting_engine: spy).diff

      assert_equal(1, diff.size)
    end

    it 'finds elements that differ for complex change' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right.merge!({ b: { c: 'd' } })

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(2, diff.size)
    end
  end

  describe '#report' do
    it 'uses report engine to build a visual representation of changes' do
      report = HashDeepDiff::Comparison.new({}, {}, delta_engine: spy, reporting_engine: spy).report

      assert_equal('', report)
    end
  end
end
