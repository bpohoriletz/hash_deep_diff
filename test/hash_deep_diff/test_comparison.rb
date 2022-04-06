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

      assert_equal([left, {}, {}], diff.map(&:to_h))
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

      assert_equal([{}, { b: [{ d: 'd' }, { c: { left: 'c', right: 'd' } }, {}] }, {}], diff)
    end

    it 'finds difference for hash with numeric values' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right.merge!({ b: { c: 'd', e: 3 } })

      diff = HashDeepDiff::Comparison.new(left, right).diff { |value| value.sort if value.respond_to?(:sort) }

      assert_equal([{}, { b: [{ d: 'd' }, { c: { left: 'c', right: 'd' } }, { e: 3 }] }, {}], diff)
    end
  end

  describe '#diff' do
    it 'finds difference for hash with numeric values' do
      left, right = load_fixture('n_level/big', 'n_level/huge')
      right.merge!({ f: { g: { h: 'j' } } })

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(
        [{ g: [1, 2, 3] },
         { b: [{}, { c: [{}, { e: { left: [1, 2, 3], right: { f: { g: [1, 2, 3] }, h: { i: { j: { k: 'k', l: 'l' }, m: 'm' }, n: 'n' }, o: 'o', p: [1, 2, 3] } } }, { r: 'r', s: { t: 't', u: 'u', v: { w: 'w', x: { y: { z: 'z' } } } } }] }, {}], f: { left: 'f', right: { g: { h: 'j' } } }, h: [{ n: 'n' }, { i: [{}, { j: { left: { k: 'k', l: 'l' }, right: 'j' }, m: { left: 'm', right: { n: 'n' } } }, { k: 'k', l: 'l' }] }, {}] }, {}],
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

      report = "#{HashDeepDiff::Comparison.new(left, right).report}\n"

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

      report = "#{HashDeepDiff::Comparison.new(left, right).report}\n"

      assert_equal(diff, report)
    end

    it 'lists elements not found on the left for simple hashes' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      left.delete(:b)
      diff = <<~Q
        -left[b][c] = c
        -left[b][d] = d
      Q

      report = "#{HashDeepDiff::Comparison.new(left, right).report}\n"

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

      report = "#{HashDeepDiff::Comparison.new(left, right).report}\n"

      assert_equal(diff, report)
    end

    it 'reports difference for simple hashes' do
      left, right = load_fixture('two_level/big', 'two_level/big')
      right[:b][:c] = :d
      diff = <<~Q
        -left[b][c] = c
        +right[b][c] = d
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end
  end

  describe '#report' do
    it 'builds git diff like text with discrepancies btween two hashes for deep additions' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      right[:b][:c][:i] = :i
      diff = '-left[b][c][i] = i'

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies btween two hashes for deep deletions' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      left[:h][:i][:j].delete(:k)
      diff = '-left[h][i][j][k] = k'

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies btween two hashes for deep changes' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      left[:h][:i][:j][:k] = 'm'
      diff = <<~Q
        -left[h][i][j][k] = m
        +right[h][i][j][k] = k
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies btween two hashes for deep changes' do
      left, right = load_fixture('n_level/huge', 'n_level/big')
      diff = <<~Q
        -left[g] = [1, 2, 3]
        +left[b][c][r] = r
        +left[b][c][s][t] = t
        +left[b][c][s][u] = u
        +left[b][c][s][v][w] = w
        +left[b][c][s][v][x][y][z] = z
        -left[b][c][e] = {:f=>{:g=>[1, 2, 3]}, :h=>{:i=>{:j=>{:k=>\"k\", :l=>\"l\"}, :m=>\"m\"}, :n=>\"n\"}, :o=>\"o\", :p=>[1, 2, 3]}
        +right[b][c][e] = [1, 2, 3]

        +left[h][i][k] = k
        +left[h][i][l] = l
        -left[h][i][j] = j
        +right[h][i][j] = {:k=>\"k\", :l=>\"l\"}

        -left[h][i][m] = {:n=>\"n\"}
        +right[h][i][m] = m
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end
  end
end
