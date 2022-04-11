# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Right do
  let(:data) { load_fixture('one_level/small') }

  it 'is convertable to string' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: data[:a])

    assert_equal('-left[a] = b', subject.to_s)
  end
end
