# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::ChangeKey do
  let(:spy) { Naught.build }
  let(:described_class) { HashDeepDiff::ChangeKey }

  describe '.initial_object' do
    let(:hash_comparison) { [[[:a], :b]] }
    let(:hash_in_array_comparison) { [[['{}'], :b]] }
    let(:array_comparison) { [[['...'], :b]] }

    it 'returns hash for hash comparison' do
      assert_equal({}, described_class.initial_object(values: hash_comparison))
    end

    it 'returns array for hash in array comparison' do
      assert_equal([], described_class.initial_object(values: hash_in_array_comparison))
    end

    it 'returns array for array comparison' do
      assert_equal([], described_class.initial_object(values: array_comparison))
    end
  end

  describe '.dig_set' do
    let(:change) { [[:a], :b] }
    let(:array_change) { [[:a], %i[c d]] }
    let(:deep_array_change) { [[:a, :b, '...'], %i[b c]] }
    let(:deep_array_hash_change) { [[:a, :b, '{}', :c], :b] }
    let(:array_first_change) { [['{}', :a, :b], %i[b c]] }
    let(:array_first_addition) { [['...'], %i[b c]] }

    it 'sets simple value within Hash' do
      report = { a: :b }

      assert_equal(report, described_class.dig_set({}, change[0], change[1]))
    end

    it 'sets array value within Hash' do
      report = { a: %i[c d] }

      assert_equal(report, described_class.dig_set({}, array_change[0], array_change[1]))
    end

    it 'sets array value deep within Hash' do
      report = { a: { b: %i[b c] } }

      assert_equal(report, described_class.dig_set({}, deep_array_change[0], deep_array_change[1]))
    end

    it 'sets value of hash within array deep within Hash' do
      report = { a: { b: [:b, :c, { c: :b }] } }
      result = described_class.dig_set({}, deep_array_change[0], deep_array_change[1])
      described_class.dig_set(result, deep_array_hash_change[0], deep_array_hash_change[1])

      assert_equal(report, result)
    end

    it 'sets value of hash within array deep within Hash - unexpcted order' do
      report = { a: { b: [:b, :c, { c: :b }] } }
      result = described_class.dig_set({}, deep_array_hash_change[0], deep_array_hash_change[1])
      described_class.dig_set(result, deep_array_change[0], deep_array_change[1])

      assert_equal(report, result)
    end

    it 'sets value if array was first element' do
      report = [:b, :c, { a: { b: %i[b c] } }]
      result = described_class.dig_set([], array_first_change[0], array_first_change[1])
      described_class.dig_set(result, array_first_addition[0], array_first_addition[1])

      assert_equal(report, result)
    end
  end
end
