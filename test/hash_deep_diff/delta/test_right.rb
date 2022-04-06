# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Right do
  let(:subject) { HashDeepDiff::Delta::Right.new(delta: load_fixture('one_level/small')) }

  it 'is convertable to string' do
    assert_equal('{:a=>"b"}', subject.to_s)
  end
end
