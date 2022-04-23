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

  describe '#complex?' do
    it 'is false if diff does not include nested hashes' do
      refute_predicate small, :complex?
    end

    it 'is true if diff has nested hashes' do
      assert_predicate medium, :complex?
    end
  end

  describe '#simple_right?' do
    it 'is false if right part of diff includes nested hashes' do
      refute_predicate mediumsmall, :simple_right?
    end

    it 'is true if right part of diff has no nested hashes' do
      assert_predicate smallmedium, :simple_right?
    end
  end

  describe '#simple_left?' do
    it 'is false if left part of diff includes nested hashes' do
      refute_predicate smallmedium, :simple_left?
    end

    it 'is true if left part of diff has no nested hashes' do
      assert_predicate mediumsmall, :simple_left?
    end
  end
end
