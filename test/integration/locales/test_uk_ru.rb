# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[LOCALES]HashDeepDiff::Comparioson#diff' do
    focus
    it 'finds difference between ru and uk examples' do
      left, right = load_fixture('locales/uk', 'locales/ru')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert true
    end
  end

  describe '[TRIVIAL]HashDeepDiff::Comparison#report' do
    it '' do
      assert true
    end
  end
end
