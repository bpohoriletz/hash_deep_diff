# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Inner do
  let(:small) { HashDeepDiff::Delta::Inner.new(path: :a, value: { left: :a, right: :b }) }
  let(:mediumsmall) { HashDeepDiff::Delta::Inner.new(path: :a, value: { left: :a, right: { b: :b } }) }
  let(:medium) { HashDeepDiff::Delta::Inner.new(path: :a, value: { left: { a: :a }, right: { b: :b } }) }

  describe '#to_s' do
    it 'is convertable to string' do
      assert_equal("-left[a] = a\n+right[a] = b", small.to_s)
    end
  end

  describe '#complex?' do
    it 'is false if diff does not include nested hashes' do
      assert !small.complex?
    end

    it 'is false if only one part of diff includes nested hashes' do
      assert !mediumsmall.complex?
    end

    it 'is true if diff has nested hashes' do
      assert medium.complex?
    end
  end
end
