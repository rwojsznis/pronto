# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'pronto/version'
require 'English'

Gem::Specification.new do |s|
  s.name = 'pronto'
  s.version = Pronto::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.author = 'Mindaugas Mozūras'
  s.email = 'mindaugas.mozuras@gmail.com'
  s.homepage = 'https://github.com/prontolabs/pronto'
  s.summary = 'Pronto runs analysis by checking only the introduced changes'
  s.description = <<-EOF
    Pronto runs analysis quickly by checking only the relevant changes. Created
    to be used on pull requests, but suited for other scenarios as well. Perfect
    if you want to find out quickly if branch introduces changes that conform to
    your styleguide, are DRY, don't introduce security holes and more.
  EOF

  s.licenses = ['MIT']
  s.required_ruby_version = '>= 2.3.0'
  s.rubygems_version = '1.8.23'

  s.files = [
    "bin/pronto",
    "lib/pronto.rb",
    "lib/pronto/cli.rb",
    "lib/pronto/comment.rb",
    "lib/pronto/config.rb",
    "lib/pronto/config_file.rb",
    "lib/pronto/error.rb",
    "lib/pronto/formatter/base.rb",
    "lib/pronto/formatter/checkstyle_formatter.rb",
    "lib/pronto/formatter/colorizable.rb",
    "lib/pronto/formatter/formatter.rb",
    "lib/pronto/formatter/json_formatter.rb",
    "lib/pronto/formatter/null_formatter.rb",
    "lib/pronto/formatter/text_formatter.rb",
    "lib/pronto/formatter/text_message_decorator.rb",
    "lib/pronto/gem_names.rb",
    "lib/pronto/git/line.rb",
    "lib/pronto/git/patch.rb",
    "lib/pronto/git/patches.rb",
    "lib/pronto/git/repository.rb",
    "lib/pronto/logger.rb",
    "lib/pronto/message.rb",
    "lib/pronto/plugin.rb",
    "lib/pronto/runner.rb",
    "lib/pronto/runners.rb",
    "lib/pronto/status.rb",
    "lib/pronto/version.rb",
    "pronto.gemspec"
  ]
  s.test_files = []
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_runtime_dependency('rugged', '>= 0.23.0', '< 2.0')
  s.add_runtime_dependency('thor', '>= 0.20.3', '< 2.0')
  s.add_development_dependency('bundler', '>= 1.15')
  s.add_development_dependency('pronto-rubocop', '~> 0.10.0')
  s.add_development_dependency('rake', '~> 12.0')
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency('rspec-its', '~> 1.2')
  s.add_development_dependency('rspec-expectations', '~> 3.4')
  s.add_development_dependency('rubocop', '~> 0.58')
  s.add_development_dependency('simplecov', '~> 0.17', '!= 0.18.0', '!= 0.18.1', '!= 0.18.2', '!= 0.18.3', '!= 0.18.4',
                               '!= 0.18.5', '!= 0.19.0', '!= 0.19.1') # see https://docs.codeclimate.com/docs/configuring-test-coverage
end
