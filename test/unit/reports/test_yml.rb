# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Reports::Yml do
  let(:described_class) { HashDeepDiff::Reports::Yml }
  let(:spy) { Naught.build { |config| config.impersonate HashDeepDiff::ChangeKey } }
  let(:delta) { Struct.new(:change_key, :left, :right, :addition, :deletion) }
  let(:change) { delta.new([:a], :b, :c, :c, :b) }
  let(:deletion) { delta.new([:a], :b, HashDeepDiff::NO_VALUE, HashDeepDiff::NO_VALUE, :b) }
  let(:addition) { delta.new([:a], HashDeepDiff::NO_VALUE, :c, :c, HashDeepDiff::NO_VALUE) }

  describe '#report' do
    it 'reports additions and deletions as yml' do
      instance = described_class.new(diff: [change], change_key_engine: spy)
      report = <<~Q
        ---
        :additions:
          :a: :c
        :deletions:
          :a: :b
      Q

      assert_equal(report, instance.report)
    end

    it 'excludes addition for deletion' do
      instance = described_class.new(diff: [deletion], change_key_engine: spy)
      report = <<~Q
        ---
        :additions: {}
        :deletions:
          :a: :b
      Q

      assert_equal(report, instance.report)
    end

    it 'excludes deletion for addition' do
      instance = described_class.new(diff: [addition], change_key_engine: spy)
      report = <<~Q
        ---
        :additions:
          :a: :c
        :deletions: {}
      Q

      assert_equal(report, instance.report)
    end
  end
end
