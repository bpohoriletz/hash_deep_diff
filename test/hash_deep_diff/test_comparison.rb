# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Comparison do
  describe '#diff (for one level deep hashes)' do
    it 'finds an empty hash if left quals right' do
      left, right = load_fixture('one_level/small', 'one_level/small')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, {}], diff)
    end

    it 'finds left if right is empty' do
      left, right = load_fixture('one_level/small', 'empty')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([left, {}, {}], diff)
    end

    it 'finds right if left is empty' do
      left, right = load_fixture('empty', 'one_level/small')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, {}, right], diff)
    end

    it 'finds difference for hash with string values' do
      left, right = load_fixture('one_level/big', 'one_level/medium')

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: 'b' }, {}, {}], diff)
    end

    it 'finds difference for hash with numeric values' do
      left, right = load_fixture('one_level/huge', 'one_level/huge')
      right.merge!({ z: 'z', c: 'ccc' })
      right.delete(:a)

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{ a: 'a' }, { c: { left: 3, right: 'ccc' } }, { z: 'z' }], diff)
    end

    it 'finds difference for hash with values of core types' do
      left, right = load_fixture('one_level/huge', 'one_level/huge')
      right.merge!({ g: Set[1, 2] })

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, { g: { left: 'ggg', right: Set[1, 2] } }, {}], diff)
    end

    it 'finds difference for hash with unsorted arrays' do
      left, right = load_fixture('one_level/big', 'one_level/big')
      left.merge!({ c: [1, 2, 3] })
      right.merge!({ c: [1, 3, 2] })

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal([{}, { c: { left: [1, 2, 3], right: [1, 3, 2] } }, {}], diff)
    end

    it 'finds difference for hash with converted values' do
      left, right = load_fixture('one_level/big', 'one_level/big')
      left.merge!({ c: [1, 2, 3] })
      right.merge!({ c: [1, 3, 2] })

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, {}, {}], diff)
    end
  end

  describe '#diff (for two level deep hashes)' do
    it 'finds difference for hash with string values' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right.merge!({ b: { c: 'd' } })

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, {:b=>[{:d=>"d"}, {:c=>{:left=>"c", :right=>"d"}}, {}]}, {}], diff)
    end

    it 'finds difference for hash with numeric values' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right.merge!({ b: { c: 'd', e: 3 } })

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, {:b=>[{:d=>"d"}, {:c=>{:left=>"c", :right=>"d"}}, {:e=>3}]}, {}], diff)
    end
  end

  describe '#diff' do
    it 'finds difference for hash with numeric values' do
      left, right = load_fixture('n_level/big', 'n_level/huge')
      right.merge!({ f: { g: { h: 'j' } } })

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(
        [{}, { b: [{}, {}, { d: 'd' }], f: [{}, { g: [{}, { h: { left: 'h', right: 'j' } }, {}] }, {}] },
         { a: 'a' }],
        diff
      )
    end
  end

  describe '#report (for one level deep hashes) ' do
    it 'lists elements not found on the right' do
      left, right = load_fixture('one_level/small', 'empty')

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal('+left[a] = b', report)
    end

    it 'lists elements missing on the left' do
      left, right = load_fixture('empty', 'one_level/small')

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal('-left[a] = b', report)
    end

    it 'lists elements that are different' do
      left, right = load_fixture('one_level/big', 'one_level/big')
      left.merge!({ c: [1, 2, 3] })
      right.merge!({ c: [1, 3, 2] })
      diff = <<~Q
        -left[c] = [1, 2, 3]
        +right[c] = [1, 3, 2]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end
  end

  describe '#report (for two level deep hashes) ' do
    it 'lists elements not found on the right for simple hashes' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right.delete(:b)
      diff = <<~Q
        +left[b][c] = c
        +left[b][d] = d
      Q

      report = HashDeepDiff::Comparison.new(left, right).report + "\n"

      assert_equal(diff, report)
    end

    it 'lists elements not found on the right for complex hashes' do
      left, right = load_fixture('two_level/huge', 'two_level/huge')
      right.delete(:b)
      diff = <<~Q
        +left[b][c] = c
        +left[b][d] = d
        +left[b][e] = [1, 2, 3]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report + "\n"

      assert_equal(diff, report)
    end

    it 'lists elements not found on the left for simple hashes' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      left.delete(:b)
      diff = <<~Q
        -left[b][c] = c
        -left[b][d] = d
      Q

      report = HashDeepDiff::Comparison.new(left, right).report + "\n"

      assert_equal(diff, report)
    end

    it 'lists elements not found on the left for complex hashes' do
      left, right = load_fixture('two_level/huge', 'two_level/huge')
      left.delete(:b)
      diff = <<~Q
        -left[b][c] = c
        -left[b][d] = d
        -left[b][e] = [1, 2, 3]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report + "\n"

      assert_equal(diff, report)
    end
  end
end
