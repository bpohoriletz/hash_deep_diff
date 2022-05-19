# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Reports::Yml do
  let(:described_class) { HashDeepDiff::Reports::Yml }
  let(:change) { HashDeepDiff::Delta.new(path: ['a'], value: { left: :b, right: :c }) }
  let(:deletion) { HashDeepDiff::Delta.new(path: ['a'], value: { left: :b, right: HashDeepDiff::NO_VALUE }) }
  let(:addition) { HashDeepDiff::Delta.new(path: ['a'], value: { left: HashDeepDiff::NO_VALUE, right: :c }) }

  describe '#report' do
    it 'reports additions and deletions as yml' do
      instance = described_class.new(diff: [change])
      report = <<~Q
        ---
        additions:
          a: :c
        deletions:
          a: :b
      Q

      assert_equal(report, instance.report)
    end

    it 'excludes addition for deletion' do
      instance = described_class.new(diff: [deletion])
      report = <<~Q
        ---
        additions: {}
        deletions:
          a: :b
      Q

      assert_equal(report, instance.report)
    end

    it 'excludes deletion for addition' do
      instance = described_class.new(diff: [addition])
      report = <<~Q
        ---
        additions:
          a: :c
        deletions: {}
      Q

      assert_equal(report, instance.report)
    end
  end
end
