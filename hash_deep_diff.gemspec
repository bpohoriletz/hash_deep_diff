# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_deep_diff/version'

Gem::Specification.new do |spec|
  spec.name          = 'hash_deep_diff'
  spec.version       = HashDeepDiff::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ['Bohdan Pohorilets']
  spec.email         = ['bohdan.pohorilets@gmail.com']

  spec.summary       = 'Deep diff for Ruby Hash objects'
  spec.description   = 'Find the exact difference between two Hash objects'
  spec.homepage      = 'https://github.com/bpohoriletz/hash_deep_diff'
  spec.required_ruby_version = '>= 2.6.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/bpohoriletz/hash_deep_diff'
    spec.metadata['changelog_uri'] = 'https://github.com/bpohoriletz/hash_deep_diff/blob/main/CHANGELOG.md'
    spec.metadata['rubygems_mfa_required'] = 'true'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3.11'
  spec.add_development_dependency 'guard', '~> 2.18.0'
  spec.add_development_dependency 'guard-minitest', '~> 2.4.6'
  spec.add_development_dependency 'guard-rubocop', '~> 1.5.0'
  spec.add_development_dependency 'minitest', '~> 5.15.0'
  spec.add_development_dependency 'minitest-focus', '~> 1.3.1'
  spec.add_development_dependency 'minitest-reporters', '~> 1.5.0'
  spec.add_development_dependency 'rake', '~> 10.5.0'
  spec.add_development_dependency 'rubocop', '~> 1.26.1'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.18.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
end
