# frozen_string_literal: true

require_relative "lib/mailhook/version"

Gem::Specification.new do |spec|
  spec.name = "mailhook"
  spec.version = Mailhook::VERSION
  spec.authors = ["Zakarias"]
  spec.email = ["zaksantanu@gmail.com"]

  spec.summary = "Ruby client for the Mailhook API"
  spec.description = "A Ruby wrapper for the Mailhook API for email testing and management."
  spec.homepage = "https://github.com/mailhook/mailhook-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.0", "< 3.0"
  spec.add_dependency "faraday-retry", "~> 2.0"
end
