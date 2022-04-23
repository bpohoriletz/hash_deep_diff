# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff' do
    it 'returns an empty hash if left quals right' do
      left, right = load_fixture('two_level/small', 'two_level/small')
      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_empty(diff)
    end
  end

  describe '#report' do
    it 'uses report engine to report diff' do
      left, right = load_fixture('two_level/small', 'empty')
      report = HashDeepDiff::Comparison.new(left, right, reporting_engine: Naught.build).report

      assert_equal('', report)
    end
  end
end
