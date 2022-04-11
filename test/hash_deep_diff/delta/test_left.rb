# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Left do
  it 'is convertable to string' do
    subject = HashDeepDiff::Delta::Left.new(delta: load_fixture('one_level/small'))

    assert_equal('+left[a] = b', subject.to_s)
  end

  it 'appends prefix to a report' do
    subject = HashDeepDiff::Delta::Left.new(delta: load_fixture('one_level/small'), prefix: [:b])

    assert_equal('+left[b][a] = b', subject.to_s)
  end
end
