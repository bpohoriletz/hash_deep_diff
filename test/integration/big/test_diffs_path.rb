# frozen_string_literal: true

require 'test_helper'

describe 'Integration tests: ' do
  describe '[BIG]HashDeepDiff::Comparison#diff' do
    let(:expectation) do
      [%i[b c e],
       %i[b c e f],
       %i[b c e f g],
       %i[b c e h],
       %i[b c e h i],
       %i[b c e h i j],
       %i[b c e h i j k],
       %i[b c e h i j l],
       %i[b c e h i m],
       %i[b c e h n],
       %i[b c e o],
       %i[b c e p],
       %i[b c e],
       %i[b c r],
       %i[b c s],
       %i[b c s t],
       %i[b c s u],
       %i[b c s v],
       %i[b c s v w],
       %i[b c s v x],
       %i[b c s v x y],
       %i[b c s v x y z],
       [:f],
       %i[f g],
       %i[f g h],
       [:f],
       [:g],
       %i[h i j],
       %i[h i j],
       %i[h i j k],
       %i[h i j l],
       %i[h i m],
       %i[h i m n],
       %i[h i m],
       %i[h i k],
       %i[h i l],
       %i[h n]]
    end

    it 'reports correct change keys for elements' do
      left, right = load_fixture('n_level/big', 'n_level/huge')
      right[:f] = { g: { h: 'j' } }

      diff = HashDeepDiff::Comparison.new(left, right).diff

      assert_equal(expectation, diff.map(&:change_key))
    end
  end
end
