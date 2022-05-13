# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Reports::Diff do
  let(:described_class) { HashDeepDiff::Reports::Diff }
  let(:delta) { Struct.new(:change_key, :left, :right) }
  let(:change) { delta.new([:a], :b, :c) }
  let(:array_change) { delta.new([:a], :b, %i[c d]) }
  let(:two_arrays) { delta.new([:a], %i[b c], %i[c d]) }
  let(:deletion) { delta.new([:a], :b, HashDeepDiff::NO_VALUE) }
  let(:addition) { delta.new([:a], HashDeepDiff::NO_VALUE, :c) }

  describe '#to_str' do
    it 'includes addition and deletion for changes' do
      instance = described_class.new(diff: [change])
      report = <<~Q
        -left[a] = b
        +left[a] = c
      Q

      assert_equal(report, instance.to_s)
    end

    it 'excludes addition for deletion' do
      instance = described_class.new(diff: [deletion])
      report = <<~Q
        -left[a] = b
      Q

      assert_equal(report, instance.to_s)
    end

    it 'excludes deletion for addition' do
      instance = described_class.new(diff: [addition])
      report = <<~Q
        +left[a] = c
      Q

      assert_equal(report, instance.to_s)
    end

    it 'formats arrays for report' do
      instance = described_class.new(diff: [array_change])
      report = <<~Q
        -left[a] = b
        +left[a] = [:c, :d]
      Q

      assert_equal(report, instance.to_s)
    end

    it 'reports difference betwen arrays' do
      instance = described_class.new(diff: [two_arrays])
      report = <<~Q
        -left[a] = [:b]
        +left[a] = [:d]
      Q

      assert_equal(report, instance.to_s)
    end
  end
end
