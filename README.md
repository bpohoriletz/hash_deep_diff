# HashDeepDiff

Find the exact difference between two Hash objects and build a report to visualize it

[![Gem
Version](https://badge.fury.io/rb/hash_deep_diff.svg)](https://badge.fury.io/rb/hash_deep_diff)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_deep_diff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_deep_diff

## Usage
Basic example

```ruby
left = { a: :a }
right = { a: :b }

HashDeepDiff::Comparison.new(left, right).report
```
```diff
- left[a] = a
+ left[a] = b
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [bpohoriletz](https://github.com/bpohoriletz/hash_deep_diff).
	
