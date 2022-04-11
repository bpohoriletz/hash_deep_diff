# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Left do
  let(:subject) { HashDeepDiff::Delta::Inner.new(path: :a, value: { left: :a, right: :b }) }

  it 'is convertable to string' do
    assert_equal("-left[a] = a\n+right[a] = b", subject.to_s)
  end
end
