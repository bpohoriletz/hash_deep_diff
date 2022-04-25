# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '#report (for two level deep hashes) ' do
    it 'lists elements not found on the right for complex hashes' do
      left, right = load_fixture('two_level/huge', 'two_level/huge')
      right.delete(:b)
      diff = <<~Q
        -left[b] = {}
        -left[b][c] = c
        -left[b][d] = d
        -left[b][e] = [1, 2, 3]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'lists elements not found on the left for complex hashes' do
      left, right = load_fixture('two_level/huge', 'two_level/huge')
      left.delete(:b)
      diff = <<~Q
        +left[b] = {}
        +left[b][c] = c
        +left[b][d] = d
        +left[b][e] = [1, 2, 3]
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies between two hashes for deep additions' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      right[:b][:c][:i] = :i
      diff = "+left[b][c][i] = i\n"

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies btween two hashes for deep deletions' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      left[:h][:i][:j].delete(:k)
      diff = "+left[h][i][j][k] = k\n"

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end

    it 'builds git diff like text with discrepancies btween two hashes for deep changes' do
      left, right = load_fixture('n_level/big', 'n_level/big')
      left[:h][:i][:j][:k] = 'm'
      diff = <<~Q
        -left[h][i][j][k] = m
        +left[h][i][j][k] = k
      Q

      report = HashDeepDiff::Comparison.new(left, right).report

      assert_equal(diff, report)
    end
  end
end
