# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  let(:left) { { a: [1, 2, 3] } }
  let(:right) { { a: [3, 4, 5] } }
  let(:medium_left) { { a: [1, 2, 3, { a: :b }] } }
  let(:medium_right) { { a: [3, { a: :c }, 4, 5] } }

  describe '[ARRAYS]HashDeepDiff::Comparison#diff' do
    it 'finds difference between two arrays' do
      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: { left: [1, 2, 3], right: [3, 4, 5] } }], diff)
    end

    it 'finds difference between arrays with simple hashes' do
      diff = HashDeepDiff::Comparison.new(medium_left, medium_right).diff

      assert_equal([{ '...' => { left: [1, 2, 3], right: [3, 4, 5] } }, { a: { left: :b, right: :c } }],
                   diff)
    end

    it 'differences between arrays with simple hashes has correct paths' do
      diff = HashDeepDiff::Comparison.new(medium_left, medium_right).diff

      assert_equal([[:a, '...'], [:a, '{}', :a]], diff.map(&:change_key))
    end
  end

  describe '[ARRAYS]HashDeepDiff::Comparison#report' do
    it 'reports difference between two arrays' do
      diff = <<~Q
        -left[a] = [1, 2]
        +left[a] = [4, 5]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'reports difference between arrays with simple hashes' do
      diff = <<~Q
        -left[a][...] = [1, 2]
        +left[a][...] = [4, 5]
        -left[a][{}][a] = b
        +left[a][{}][a] = c
      Q

      report = HashDeepDiff::Comparison.new(medium_left, medium_right).report

      assert_equal(diff, report)
    end
  end
end
