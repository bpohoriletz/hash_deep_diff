# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[BIG]HashDeepDiff::Comparison#diff' do
    let(:expectation) do
      [{ e: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { e: { left: [1, 2, 3], right: HashDeepDiff::NO_VALUE } },
       { r: { left: HashDeepDiff::NO_VALUE, right: 'r' } },
       { s: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { t: { left: HashDeepDiff::NO_VALUE, right: 't' } },
       { u: { left: HashDeepDiff::NO_VALUE, right: 'u' } },
       { v: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { w: { left: HashDeepDiff::NO_VALUE, right: 'w' } },
       { x: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { y: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { z: { left: HashDeepDiff::NO_VALUE, right: 'z' } },
       { f: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { g: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { h: { left: HashDeepDiff::NO_VALUE, right: 'j' } },
       { f: { left: 'f', right: HashDeepDiff::NO_VALUE } },
       { g: { left: [1, 2, 3], right: HashDeepDiff::NO_VALUE } },
       { j: { left: {}, right: HashDeepDiff::NO_VALUE } },
       { j: { left: HashDeepDiff::NO_VALUE, right: 'j' } },
       { k: { left: 'k', right: HashDeepDiff::NO_VALUE } },
       { l: { left: 'l', right: HashDeepDiff::NO_VALUE } },
       { m: { left: HashDeepDiff::NO_VALUE, right: {} } },
       { n: { left: HashDeepDiff::NO_VALUE, right: 'n' } },
       { m: { left: 'm', right: HashDeepDiff::NO_VALUE } },
       { k: { left: HashDeepDiff::NO_VALUE, right: 'k' } },
       { l: { left: HashDeepDiff::NO_VALUE, right: 'l' } },
       { n: { left: 'n', right: HashDeepDiff::NO_VALUE } }]
    end

    it 'reports elements that are different' do
      left, right = load_fixture('n_level/big', 'n_level/huge')
      right[:f] = { g: { h: 'j' } }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(expectation, diff)
    end
  end
end
