# frozen_string_literal: true

require_relative "lib/activerecord/pinot/adapter/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-pinot-adapter"
  spec.version = Activerecord::Pinot::Adapter::VERSION
  spec.authors = ["Celso Fernandes"]
  spec.email = ["celso.fernandes@clickfunnels.com"]

  spec.summary = "ActiveRecord Apache Pinot Adapter"
  spec.description = "ActiveRecord Apache Pinot Adapter"
  spec.homepage = "https://github.com/fernandes/activerecord-pinot-adapter"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fernandes/activerecord-pinot-adapter"
  spec.metadata["changelog_uri"] = "https://github.com/fernandes/activerecord-pinot-adapter/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_runtime_dependency "activerecord", ">= 5.2.0", "< 7.2"
  spec.add_runtime_dependency "pinot"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "minitest-focus"
end
