# HashDeepDiff
[![Gem
Version](https://badge.fury.io/rb/hash_deep_diff.svg)](https://badge.fury.io/rb/hash_deep_diff) ![GitHub Workflow
Status](https://img.shields.io/github/workflow/status/bpohoriletz/hash_deep_diff/CI)
![GitHub](https://img.shields.io/github/license/bpohoriletz/hash_deep_diff)


Find the exact difference between two Hash objects and build a report to visualize it. Works for other objects too but why would you do that :/

Alternative solutions [hashdiff](https://github.com/liufengyun/hashdiff) by liufengyun and [hash_diff](https://github.com/CodingZeal/hash_diff) by CodingZeal

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
### Basic

```ruby
left = { a: :a }
right = { a: :b }

print HashDeepDiff::Comparison.new(left, right).report
```
```diff
- left[a] = a
+ left[a] = b
```
### Arrays
```ruby
left = [1, 2, { a: :a }]
right = [2, { a: :b }, 3]

print HashDeepDiff::Comparison.new(left, right).report
```
```diff
-left[...] = [1]
+left[...] = [3]
-left[{}][a] = a
+left[{}][a] = b
```
### Nesting
```ruby
left  = { a: [1, 2, { a: :a } ], b: { c: [1, 2, { d: :e } ] } }
right = { a: [2, { a: :b }, 3], b: { c: { f: { g: :h } } } }

print HashDeepDiff::Comparison.new(left, right).report
```
```diff
-left[a][...] = [1]
+left[a][...] = [3]
-left[a][{}][a] = a
+left[a][{}][a] = b
+left[b][c][...][f] = {}
+left[b][c][...][f][g] = h
-left[b][c][...][f] = [1, 2]
-left[b][c][{}][d] = e
```
### Reporting Engines
You can choose from the default diff-like reporting engine (examples are above) and YML reporting engine

```ruby
left  = { a: [1, 2, { a: :a } ], b: { c: [1, 2, { d: :e } ] } }
right = { a: [2, { a: :b }, 3], b: { c: { f: { g: :h } } } }
```
#### Raw Report

```ruby
print HashDeepDiff::Comparison.new(left, right, reporting_engine: HashDeepDiff::Reports::Yml).raw_report
=> {"additions"=>{:a=>[3, {:a=>:b}], :b=>{:c=>[{:f=>{:g=>:h}}]}},
    "deletions"=>{:a=>[1, {:a=>:a}], :b=>{:c=>[1, 2, {:d=>:e}]}}}
```

#### YML Report

```ruby
print HashDeepDiff::Comparison.new(left, right, reporting_engine: HashDeepDiff::Reports::Yml).report

---
additions:
  :a:
  - 3
  - :a: :b
  :b:
    :c:
    - :f:
        :g: :h
deletions:
  :a:
  - 1
  - :a: :a
  :b:
    :c:
    - 1
    - 2
    - :d: :e
```

please see [Documentation](https://rdoc.info/gems/hash_deep_diff/HashDeepDiff/Comparison) for
more information or [Reporting test](https://github.com/bpohoriletz/hash_deep_diff/blob/a525d239189b0310aec3741dfc4862834805252d/test/integration/locales/test_uk_ru.rb#L59)



## Customization

You can implement and use your own reporting engines with the default `HashDeepDiff::Delta` objects as a source of the report. In order to do so implement your own version of the reporting engine (example can be found [here](https://github.com/bpohoriletz/hash_deep_diff/tree/main/lib/hash_deep_diff/reports)) and inject it into a `Comparison`

```ruby
left = { a: :a }
right = { a: :b }

HashDeepDiff::Comparison.new(left, right, reporting_engine: CustomEngine).report
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [bpohoriletz](https://github.com/bpohoriletz/hash_deep_diff).
	
