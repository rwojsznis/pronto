module Pronto
  class ConfigFile
    DEFAULT_MESSAGE_FORMAT = '%{msg}'.freeze
    DEFAULT_WARNINGS_PER_REVIEW = 30

    EMPTY = {
      'all' => {
        'exclude' => [],
        'include' => []
      },
      'text' => {
        'format' => '%{color_location} %{color_level}: %{msg}'
      },
      'default_commit' => 'master',
      'runners' => [],
      'formatters' => [],
      'max_warnings' => nil,
      'warnings_per_review' => DEFAULT_WARNINGS_PER_REVIEW,
      'verbose' => false,
      'format' => DEFAULT_MESSAGE_FORMAT
    }.freeze

    attr_reader :path

    def initialize(path = ENV.fetch('PRONTO_CONFIG_FILE', '.pronto.yml'))
      @path = path
    end

    def to_h
      hash = File.exist?(@path) ? YAML.load_file(@path) : {}
      deep_merge(hash)
    end

    private

    def deep_merge(hash)
      merger = proc do |_, oldval, newval|
        if oldval.is_a?(Hash) && newval.is_a?(Hash)
          oldval.merge(newval, &merger)
        else
          oldval.nil? ? newval : oldval
        end
      end

      hash.merge(EMPTY, &merger)
    end
  end
end
