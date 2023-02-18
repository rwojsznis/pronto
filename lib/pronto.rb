require 'rugged'
require 'forwardable'
require 'rainbow'
require 'yaml'
require 'pronto/error'

require 'pronto/gem_names'

require 'pronto/logger'
require 'pronto/config_file'
require 'pronto/config'

require 'pronto/git/repository'
require 'pronto/git/patches'
require 'pronto/git/patch'
require 'pronto/git/line'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/comment'
require 'pronto/status'
require 'pronto/runner'
require 'pronto/runners'

require 'pronto/formatter/colorizable'
require 'pronto/formatter/base'
require 'pronto/formatter/text_formatter'
require 'pronto/formatter/json_formatter'
require 'pronto/formatter/checkstyle_formatter'
require 'pronto/formatter/null_formatter'
require 'pronto/formatter/formatter'

module Pronto
  def self.run(commit = nil, repo_path = '.',
               formatters = [Formatter::TextFormatter.new], file = nil)
    commit ||= default_commit

    repo = Git::Repository.new(repo_path)
    options = { paths: [file] } if file
    patches = repo.diff(commit, options)

    result = Runners.new.run(patches)

    Array(formatters).each do |formatter|
      formatted = formatter.format(result, repo, patches)
      puts formatted if formatted
    end

    result
  end

  def self.default_commit
    Config.new.default_commit
  end
end
