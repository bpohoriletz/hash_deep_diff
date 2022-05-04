# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  let(:small) { { a: [1, 2, 3] } }
  let(:medium) { { a: [1, 2, 3, { a: :b }] } }

  describe '[ARRAYS]HashDeepDiff::Comparison#diff' do
    it 'finds difference between array and hash' do
      diff = HashDeepDiff::Comparison.new(small, {}).diff

      assert_equal([{ a: { left: [1, 2, 3], right: HashDeepDiff::NO_VALUE } }], diff)
    end

    it 'finds difference between complex array and hash' do
      diff = HashDeepDiff::Comparison.new(medium, { z: :x }).diff

      assert_equal([{ '...' => { left: [1, 2, 3], right: HashDeepDiff::NO_VALUE } },
                    { a: { left: :b, right: HashDeepDiff::NO_VALUE } },
                    { z: { left: HashDeepDiff::NO_VALUE, right: :x } }],
                   diff)
    end

    it 'differences between arrays with simple hashes has correct paths' do
      diff = HashDeepDiff::Comparison.new(medium, { z: :x }).diff

      assert_equal([[:a, '...'], [:a, '{}', :a], [:z]], diff.map(&:change_key))
    end
  end

  describe '[ARRAYS]HashDeepDiff::Comparison#report' do
    it 'reports difference array and string' do
      diff = <<~Q
        -left[a] = [1, 2, 3]
        +left[a] = a
      Q
      report = HashDeepDiff::Comparison.new(small, 'a').report

      assert_equal(diff, report)
    end

    it 'reports difference between array with simple hashes and NilClass' do
      diff = <<~Q
        -left[a][...] = [1, 2, 3]
        +left[a][...] = \
        \n-left[a][{}][a] = b
      Q

      report = HashDeepDiff::Comparison.new(medium, nil).report

      assert_equal(diff, report)
    end
  end
end
