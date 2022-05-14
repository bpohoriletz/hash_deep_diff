# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Reports::Yml do
  let(:described_class) { HashDeepDiff::Reports::Yml }
  let(:delta) { Struct.new(:change_key, :left, :right, :addition, :deletion) }
  let(:change) { delta.new([:a], :b, :c, :c, :b) }
  let(:array_change) { delta.new([:a], :b, %i[c d], %i[c d], :b) }
  let(:two_arrays) { delta.new([:a], %i[b c], %i[c d], [:d], [:b]) }
  let(:deletion) { delta.new([:a], :b, HashDeepDiff::NO_VALUE, HashDeepDiff::NO_VALUE, :b) }
  let(:addition) { delta.new([:a], HashDeepDiff::NO_VALUE, :c, :c, HashDeepDiff::NO_VALUE) }
  let(:deep_array_change) { delta.new([:a, :b, '...'], %i[b c], %i[c d], [:d], [:b]) }
  let(:deep_array_hash_change) { delta.new([:a, :b, '{}', :c], :b, :c, :c, :b) }

  describe '#raw_report' do
    it 'includes addition and deletion for changes' do
      instance = described_class.new(diff: [change])
      report = {
        additions: { a: :c },
        deletions: { a: :b }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'excludes addition for deletion' do
      instance = described_class.new(diff: [deletion])
      report = {
        additions: {},
        deletions: { a: :b }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'excludes deletion for addition' do
      instance = described_class.new(diff: [addition])
      report = {
        additions: { a: :c },
        deletions: {}
      }

      assert_equal(report, instance.raw_report)
    end

    it 'formats arrays for report' do
      instance = described_class.new(diff: [array_change])
      report = {
        additions: { a: %i[c d] },
        deletions: { a: :b }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'reports difference betwen arrays' do
      instance = described_class.new(diff: [two_arrays])
      report = {
        additions: { a: [:d] },
        deletions: { a: [:b] }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'reports difference betwen arrays' do
      instance = described_class.new(diff: [deep_array_change])
      report = {
        additions: { a: { b: [:d] } },
        deletions: { a: { b: [:b] } }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'reports difference betwen arrays with hashes' do
      instance = described_class.new(diff: [deep_array_change, deep_array_hash_change])
      report = {
        additions: { a: { b: [:d, { c: :c }] } },
        deletions: { a: { b: [:b, { c: :b }] } }
      }

      assert_equal(report, instance.raw_report)
    end

    it 'reports difference betwen arrays with hashes - unexpected order' do
      instance = described_class.new(diff: [deep_array_hash_change, deep_array_change])
      report = {
        additions: { a: { b: [:d, { c: :c }] } },
        deletions: { a: { b: [:b, { c: :b }] } }
      }

      assert_equal(report, instance.raw_report)
    end
  end
end
