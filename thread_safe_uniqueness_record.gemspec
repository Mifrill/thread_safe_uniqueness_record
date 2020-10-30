require_relative 'lib/thread_safe_uniqueness_record/version'

Gem::Specification.new do |spec|
  spec.name          = "thread_safe_uniqueness_record"
  spec.version       = ThreadSafeUniquenessRecord::VERSION
  spec.authors       = ["Aleksey Strizhak"]
  spec.email         = ["alexei.mifrill.strizhak@gmail.com"]

  spec.summary       = "Thread safe creation of unique ActiveRecord"
  spec.description   = "The preventer of thread race conditions for ActiveRecord unique model creations"
  spec.homepage      = "https://github.com/Mifrill/thread_safe_uniqueness_record.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Mifrill/thread_safe_uniqueness_record/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord"

  spec.add_development_dependency "rspec",        "~> 3.8"
  spec.add_development_dependency "byebug"
end
