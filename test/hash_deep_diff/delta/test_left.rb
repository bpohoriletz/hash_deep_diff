# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Left do
  let(:data) { load_fixture('one_level/small') }

  it 'is convertable to string' do
    subject = HashDeepDiff::Delta::Left.new(path: :a, value: data[:a])

    assert_equal('+left[a] = b', subject.to_s)
  end

  it 'appends prefix to a report' do
    subject = HashDeepDiff::Delta::Left.new(path: [:b, :a], value: data[:a])

    assert_equal('+left[b][a] = b', subject.to_s)
  end
end
