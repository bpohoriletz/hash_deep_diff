# frozen_string_literal: true

require 'test_helper'

describe HashDeepDiff::Delta::Right do
  let(:small) { load_fixture('one_level/small') }
  let(:medium) { load_fixture('two_level/small') }

  it 'is convertable to string' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: small[:a])

    assert_equal('-left[a] = b', subject.to_s)
  end

  it 'reports two level hashes as two lines' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: medium[:a])

    assert_equal("-left[a][b] = b\n-left[a][c] = c", subject.to_s)
  end

  it 'appends prefix to a report' do
    subject = HashDeepDiff::Delta::Right.new(path: %i[b a], value: small[:a])

    assert_equal('-left[b][a] = b', subject.to_s)
  end

  it 'reports two level hashes as two lines' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: medium[:a])

    assert_equal("-left[a][b] = b\n-left[a][c] = c", subject.to_s)
  end

  it 'is"s left diff is always nil' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: small[:a])

    assert_nil(subject.left)
  end

  it 'is"s right diff is nonempty' do
    subject = HashDeepDiff::Delta::Right.new(path: :a, value: small[:a])

    assert_equal('b', subject.right)
  end
end
