# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[ARRAYS]HashDeepDiff::Comparison#diff' do
    it 'finds difference between two arrays' do
      left = { a: [1, 2, 3] }
      right = { a: [3, 4, 5] }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: { left: [1, 2, 3], right: [3, 4, 5] } }], diff)
    end

    # focus
    # it 'finds difference between smal and empty hashes' do
    # left = { a: [1, 2, 3, { a: :b }] }
    # right = { a: [3, { a: :c }, 4, 5] }

    ## diff = HashDeepDiff::Comparison.new(left, right).diff

    # assert_equal([{ a: { left: [1, 2, 3], right: [3, 4, 5] } }], diff)
    # end
  end

  describe '[ARRAYS]HashDeepDiff::Comparison#report' do
    it 'finds difference between two arrays' do
      left = { a: [1, 2, 3] }
      right = { a: [3, 4, 5] }
      diff = <<~Q
        -left[a] = [1, 2]
        +left[a] = [4, 5]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end
  end
end
