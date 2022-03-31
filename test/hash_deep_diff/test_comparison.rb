# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff' do
    it 'returns an empty hash if left quals right' do
      diff = HashDeepDiff::Comparison.new({}, {}).diff

      assert_empty(diff)
    end
  end
end
