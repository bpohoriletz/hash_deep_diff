# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::ChangeKey do
  let(:spy) { Naught.build }
  let(:described_class) { HashDeepDiff::ChangeKey }
  let(:instance) { described_class.new(path: []) }

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

  describe '#set' do
    let(:change) { [:a] }
    let(:deep_array_change) { [:a, :b, '...'] }
    let(:deep_array_hash_change) { [:a, :b, '{}', :c] }
    let(:array_first_hash_change) { ['{}', :a, :b] }
    let(:array_first_addition) { ['...'] }

    it 'does not mutate object' do
      instance = described_class.new(path: deep_array_change)

      instance.set({}, %i[b c])

      assert_equal(deep_array_change, instance.to_a)
    end

    it 'sets simple value within Hash' do
      report = { a: :b }

      assert_equal(report, described_class.new(path: change).set({}, :b))
    end

    it 'sets array value within Hash' do
      report = { a: %i[c d] }

      assert_equal(report, described_class.new(path: change).set({}, %i[c d]))
    end

    it 'sets array value deep within Hash' do
      report = { a: { b: %i[b c] } }

      assert_equal(report, described_class.new(path: deep_array_change).set({}, %i[b c]))
    end

    it 'sets value of hash within array deep within Hash' do
      report = { a: { b: [:b, :c, { c: :b }] } }
      result = described_class.new(path: deep_array_change).set({}, %i[b c])
      described_class.new(path: deep_array_hash_change).set(result, :b)

      assert_equal(report, result)
    end

    it 'sets value of hash within array deep within Hash - unexpcted order' do
      report = { a: { b: [:c, :b, { c: :c }] } }
      result = described_class.new(path: deep_array_hash_change).set({}, :c)
      described_class.new(path: deep_array_change).set(result, %i[c b])

      assert_equal(report, result)
    end

    it 'sets value if array was first element' do
      report = [:b, :c, { a: { b: %i[c b] } }]
      result = described_class.new(path: array_first_hash_change).set([], %i[c b])
      described_class.new(path: array_first_addition).set(result, %i[b c])

      assert_equal(report, result)
    end
  end
end
