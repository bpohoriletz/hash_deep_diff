# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  let(:small) { { a: [1, 2, 3] } }
  let(:medium) { { a: [1, 2, 3, { a: :b }] } }

  describe '[ARRAYS]HashDeepDiff::Comparison#diff' do
    it 'finds difference between hash and' do
      diff = HashDeepDiff::Comparison.new({ c: :d }, small).diff

      assert_equal(
        [{ c: { left: :d, right: HashDeepDiff::NO_VALUE } },
         { a: { left: HashDeepDiff::NO_VALUE, right: [1, 2, 3] } }], diff
      )
    end

    it 'finds difference between hash and complex array' do
      diff = HashDeepDiff::Comparison.new({ z: :x }, medium).diff

      assert_equal([{ z: { left: :x, right: HashDeepDiff::NO_VALUE } },
                    { '...' => { left: HashDeepDiff::NO_VALUE, right: [1, 2, 3] } },
                    { a: { left: HashDeepDiff::NO_VALUE, right: :b } }],
                   diff)
    end

    it 'differences between hashes and arrays with simple hashes has correct paths' do
      diff = HashDeepDiff::Comparison.new({ z: :x }, medium).diff

      assert_equal([[:z], [:a, '...'], [:a, '{}', :a]], diff.map(&:change_key))
    end
  end

  describe '[ARRAYS]HashDeepDiff::Comparison#report' do
    it 'reports difference string and array' do
      diff = <<~Q
        -left[a] = a
        +left[a] = [1, 2, 3]
      Q
      report = HashDeepDiff::Comparison.new('a', small).report

      assert_equal(diff, report)
    end

    it 'reports difference between NilClass and array with simple hashes' do
      diff = <<~Q
        -left[a][...] = \
        \n+left[a][...] = [1, 2, 3]
        +left[a][{}][a] = b
      Q

      report = HashDeepDiff::Comparison.new(nil, medium).report

      assert_equal(diff, report)
    end
  end
end
