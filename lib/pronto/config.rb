module Pronto
  class Config
    def initialize(config_hash = ConfigFile.new.to_h)
      @config_hash = config_hash
    end

    def default_commit
      default_commit =
        ENV['PRONTO_DEFAULT_COMMIT'] ||
        @config_hash.fetch('default_commit', 'master')
      default_commit
    end

    def consolidate_comments?
      consolidated =
        ENV['PRONTO_CONSOLIDATE_COMMENTS'] ||
        @config_hash.fetch('consolidate_comments', false)
      consolidated
    end

    def excluded_files(runner)
      files =
        if runner == 'all'
          ENV['PRONTO_EXCLUDE'] || @config_hash['all']['exclude']
        else
          @config_hash.fetch(runner, {})['exclude']
        end

      Array(files)
        .flat_map { |path| Dir[path.to_s] }
        .map { |path| File.expand_path(path) }
    end

    def warnings_per_review
      fetch_integer('warnings_per_review')
    end

    def max_warnings
      fetch_integer('max_warnings')
    end

    def message_format(formatter)
      formatter_config = @config_hash[formatter]
      if formatter_config && formatter_config.key?('format')
        formatter_config['format']
      else
        fetch_value('format')
      end
    end

    def skip_runners
      fetch_list('skip_runners')
    end

    def runners
      fetch_list('runners')
    end

    def logger
      @logger ||= begin
        verbose = fetch_value('verbose')
        verbose ? Logger.new($stdout) : Logger.silent
      end
    end

    private

    def fetch_integer(key)
      full_key = env_key(key)

      (ENV[full_key] && Integer(ENV[full_key])) || @config_hash[key]
    end

    def fetch_value(key)
      ENV[env_key(key)] || @config_hash[key]
    end

    def env_key(key)
      "PRONTO_#{key.upcase}"
    end

    def fetch_list(key)
      Array(fetch_value(key)).flat_map do |runners|
        runners.split(',')
      end
    end
  end
end
