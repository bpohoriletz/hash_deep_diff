# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff' do
    it 'finds an empty hash if left quals right' do
      left = { a: :b }
      right = { a: :b }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, {}], diff)
    end

    it 'finds left if right is empty' do
      left = { a: :b }
      right = {}

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([left, {}, {}], diff)
    end

    it 'finds right if left is empty' do
      left = {}
      right = { c: :d }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, right], diff)
    end

    it 'finds difference for one level deep hash with string values' do
      left = { a: 'b', c: 'd', e: 'f' }
      right = { c: 'd', e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: 'b' }, {}, {}], diff)
    end

    it 'finds difference for one level deep hash with numeric values' do
      left = { a: 1, b: 2.0, c: 3, d: 4, e: 5, f: 6 }
      right = { b: 1, c: 3, d: 4, e: 5, f: 6, g: 7 }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: 1 }, { b: { left: 2.0, right: 1 } }, { g: 7 }], diff)
    end

    it 'finds difference for one level deep hash with values of core types' do
      left = { a: 1, b: 1, c: '3', d: :d, e: 5, f: 6 }
      right = { b: 1, c: 3.0, d: :d, e: 5, f: 6, g: Set[1, 2] }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: 1 }, { c: { left: '3', right: 3.0 } }, { g: Set[1, 2] }], diff)
    end

    it 'finds difference for one level deep hash with unsorted arrays' do
      left = { a: 'b', c: [1, 2, 3], e: 'f' }
      right = { a: 'b', c: [1, 3, 2], e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, { c: { left: [1, 2, 3], right: [1, 3, 2] } }, {}], diff)
    end

    it 'finds difference for one level deep hash with converted values' do
      left = { a: 'b', c: [1, 2, 3], e: 'f' }
      right = { a: 'b', c: [1, 3, 2], e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, {}, {}], diff)
    end

    it 'finds difference for two level deep hash with string values' do
      left = { a: 'b', c: { d: '2' }, e: 'f' }
      right = { a: 'b', c: { d: '3' }, e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, { c: [{}, { d: { left: '2', right: '3' } }, {}] }, {}], diff)
    end

    it 'finds difference for two level deep hash with numeric values' do
      left = { a: 'b', c: { d: 2 }, e: 'f' }
      right = { a: 'b', c: { d: 2.0, e: 3 }, e: 'f' }

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, { c: [{}, { d: { left: 2.0, right: 2.0 } }, { e: 3 }] }, {}], diff)
    end

    it 'finds difference for three level deep hash with numeric values' do
      left = { a: 'b', c: { d: 2 }, e: 'f', g: { h: { i: :j } } }
      right = { a: 'b', c: { d: 2.0, e: 3 }, e: 'f', g: { h: { i: :i } } }

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal(
        [
          {},
          {
            c: [
              {},
              { d: { left: 2, right: 2.0 } },
              { e: 3 }
            ],
            g: [
              {},
              {
                h: [
                  {},
                  { i: { left: :j, right: :i } },
                  {}
                ]
              },
              {}
            ]
          },
          {}
        ], diff
      )
    end
  end
end
