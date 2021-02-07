require_relative 'lib/thread_safe_uniqueness_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'thread_safe_uniqueness_record'
  spec.version       = ThreadSafeUniquenessRecord::VERSION
  spec.authors       = ['Aleksey Strizhak']
  spec.email         = ['alexei.mifrill.strizhak@gmail.com']

  spec.summary       = 'Thread safe creator of unique ActiveRecord model'
  spec.description   = 'Prevents of thread race conditions for ActiveRecord unique model creations'
  spec.homepage      = 'https://github.com/Mifrill/thread_safe_uniqueness_record.git'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/Mifrill/thread_safe_uniqueness_record/blob/master/CHANGELOG.md'

  spec.require_paths = ['lib']
  spec.files         = Dir['{lib}/**/*'] + %w[LICENSE.txt]

  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'concurrent-ruby'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'sqlite3'
end
