# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  let(:spy) { Naught.build }

  describe '#diff' do
    it 'returns an empty Array if empty hashes are compared' do
      diff = HashDeepDiff::Comparison.new({}, {}, reporting_engine: spy, reporting_engine: spy).diff

      assert_empty(diff)
    end

    it 'returns an empty Array if values are equal' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      diff = HashDeepDiff::Comparison.new(left, right, reporting_engine: spy, reporting_engine: spy).diff

      assert_empty(diff)
    end
  end

  describe '#report' do
    it 'uses report engine to build a visual representation of changes' do
      report = HashDeepDiff::Comparison.new({}, {}, reporting_engine: spy, reporting_engine: spy).report

      assert_equal('', report)
    end
  end
end
