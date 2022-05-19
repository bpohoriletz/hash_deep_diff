# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  let(:left) { { a: [1, 2, 3] } }
  let(:right) { { a: [3, 4, 5] } }
  let(:right_addition) { { a: [3, 4, 5, 6] } }
  let(:medium_left) { { a: [1, 2, 3, { a: :b }] } }
  let(:medium_right) { { a: [3, { a: :c }, 4, 5] } }
  let(:big_left) { { a: [1, 2, { a: :a }], b: { c: [1, 2, { d: :e }] } } }
  let(:big_right) { { a: [2, { a: :b }, 3], b: { c: { f: { g: :h } } } } }

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

    it 'differences between arrays with complex hashes' do
      diff = HashDeepDiff::Comparison.new(big_left, big_right).diff

      assert_equal(
        [{ '...' => { left: [1, 2], right: [2, 3] } },
         { a: { left: :a, right: :b } },
         { '...' => { left: [1, 2], right: HashDeepDiff::NO_VALUE } },
         { d: { left: :e, right: HashDeepDiff::NO_VALUE } },
         { f: { left: HashDeepDiff::NO_VALUE, right: {} } },
         { g: { left: HashDeepDiff::NO_VALUE, right: :h } }],
        diff
      )
    end

    it 'differences between arrays with complex hashes' do
      diff = HashDeepDiff::Comparison.new(big_left, big_right).diff

      assert_equal(
        [[:a, '...'],
         [:a, '{}', :a],
         [:b, :c, '...'],
         [:b, :c, '{}', :d],
         [:b, :c, '{}', :f],
         [:b, :c, '{}', :f, :g]],
        diff.map(&:change_key)
      )
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

    it 'reports addition to arrays' do
      diff = <<~Q
        +left[a] = [6]
      Q

      report = HashDeepDiff::Comparison.new(right, right_addition).report

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

    it 'reports difference between arrays with complex hashes' do
      diff = <<~Q
        -left[a][...] = [1]
        +left[a][...] = [3]
        -left[a][{}][a] = a
        +left[a][{}][a] = b
        -left[b][c][...] = [1, 2]
        -left[b][c][{}][d] = e
        +left[b][c][{}][f] = {}
        +left[b][c][{}][f][g] = h
      Q

      report = HashDeepDiff::Comparison.new(big_left, big_right).report

      assert_equal(diff, report)
    end
  end
end
