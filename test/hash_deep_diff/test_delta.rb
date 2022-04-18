# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta do
  let(:small) { HashDeepDiff::Delta.new(path: :a, value: { left: :a, right: :b }) }
  let(:mediumsmall) { HashDeepDiff::Delta.new(path: :a, value: { left: :a, right: { b: :b } }) }
  let(:medium) { HashDeepDiff::Delta.new(path: :a, value: { left: { a: :a }, right: { b: :b } }) }
  let(:big) do
    HashDeepDiff::Delta.new(path: :a, value: { left: load_fixture('empty'),
                                               right: load_fixture('two_level/small') })
  end

  describe '#to_s' do
    it 'is convertable to string' do
      assert_equal("-left[a] = a\n+left[a] = b", small.to_s)
    end

    it 'reports full difference betweeh hashes' do
      diff = <<~Q
        -left[a] = {}
        +left[a][a][b] = b
        +left[a][a][c] = c
      Q

      assert_equal(diff.strip, big.to_s)
    end
  end

  describe '#complex?' do
    it 'is false if diff does not include nested hashes' do
      refute_predicate small, :complex?
    end

    it 'is false if only one part of diff includes nested hashes' do
      refute_predicate mediumsmall, :complex?
    end

    it 'is true if diff has nested hashes' do
      assert_predicate medium, :complex?
    end
  end

  it 'lists elements not found on the right' do
    report = HashDeepDiff::Delta.new(path: :a,
                                     value: { left: :b,
                                              right: HashDeepDiff::NO_VALUE }).to_s

    assert_equal('-left[a] = b', report)
  end
end
