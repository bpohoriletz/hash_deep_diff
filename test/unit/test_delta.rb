# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta do
  let(:small) { HashDeepDiff::Delta.new(change_key: :a, value: { left: :a, right: :b }) }
  let(:smallmedium) { HashDeepDiff::Delta.new(change_key: :a, value: { left: { a: :a }, right: :b }) }
  let(:mediumsmall) { HashDeepDiff::Delta.new(change_key: :a, value: { left: :a, right: { b: :b } }) }
  let(:medium) { HashDeepDiff::Delta.new(change_key: :a, value: { left: { a: :a }, right: { b: :b } }) }
  let(:big) do
    HashDeepDiff::Delta.new(change_key: :a, value: { left: load_fixture('empty'),
                                                     right: load_fixture('two_level/small') })
  end
  let(:smallmedium_inside_array) do
    HashDeepDiff::Delta.new(change_key: :a, value: { left: [1, 2, { a: :a }], right: :b })
  end
  let(:mediumsmall_inside_array) do
    HashDeepDiff::Delta.new(change_key: :a, value: { left: :a, right: [{ b: :b }, 2, 3] })
  end
  let(:medium_inside_array) do
    HashDeepDiff::Delta.new(change_key: :a, value: { left: [1, 2, { a: :a }], right: [{ b: :b }, 2, 3] })
  end

  describe '#placebo' do
    it 'is empty for simple deltas' do
      assert_empty(small.placebo)
    end

    it 'is empty for complex deltas' do
      assert_empty(big.placebo)
    end

    it 'is empty left for added nesting' do
      assert_equal([{ 'a' => { left: HashDeepDiff::NO_VALUE, right: {} } }], mediumsmall.placebo)
    end

    it 'is empty left for nesting added inside array' do
      assert_equal([{ 'a' => { left: HashDeepDiff::NO_VALUE, right: [{}] } }], mediumsmall_inside_array.placebo)
    end

    it 'is empty right for added nesting' do
      assert_equal([{ 'a' => { right: HashDeepDiff::NO_VALUE, left: {} } }], smallmedium.placebo)
    end

    it 'is empty right for nesting addd inside array' do
      assert_equal([{ 'a' => { right: HashDeepDiff::NO_VALUE, left: [{}] } }], smallmedium_inside_array.placebo)
    end
  end

  describe '#composite?' do
    it 'is false if diff does not include nested hashes' do
      refute_predicate small, :composite?
    end

    it 'is true if diff has nested hashes' do
      assert_predicate medium, :composite?
    end

    it 'is true if diff is two arrays with hashes' do
      assert_predicate medium_inside_array, :composite?
    end
  end

  describe '#partial?' do
    it 'is true if right part of diff includes nested hashes' do
      assert_predicate mediumsmall, :partial?
    end

    it 'is true if right part of diff is array with hashes' do
      assert_predicate mediumsmall_inside_array, :partial?
    end

    it 'is true if left part of diff includes nested hashes' do
      assert_predicate smallmedium, :partial?
    end

    it 'is true if left part of diff is array with hashes' do
      assert_predicate smallmedium_inside_array, :partial?
    end
  end

  describe '#simple?' do
    it 'is false if left part of diff includes nested hashes' do
      refute_predicate smallmedium, :simple?
    end

    it 'is false if left part of diff is array with nested hashes' do
      refute_predicate smallmedium_inside_array, :simple?
    end

    it 'is false if right part of diff includes nested hashes' do
      refute_predicate mediumsmall, :simple?
    end

    it 'is false if right part of diff is array with hashes' do
      refute_predicate mediumsmall_inside_array, :simple?
    end

    it 'is true if diff has no nested hashes' do
      assert_predicate small, :simple?
    end
  end
end
