# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::ChangeKey do
  let(:spy) { Naught.build }
  let(:described_class) { HashDeepDiff::ChangeKey }
  let(:hash_comparison) { [[[:a], :b]]}
  let(:hash_in_array_comparison) { [[['{}'], :b]]}
  let(:array_comparison) { [[['...'], :b]]}

  describe '.initial_object' do
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
end
