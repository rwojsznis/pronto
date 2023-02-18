module Pronto
  module Formatter
    def self.get(names)
      names ||= 'text'
      Array(names).map { |name| FORMATTERS[name.to_s] || TextFormatter }
        .uniq.map(&:new)
    end

    def self.names
      FORMATTERS.keys
    end

    FORMATTERS = {
      'json' => JsonFormatter,
      'checkstyle' => CheckstyleFormatter,
      'text' => TextFormatter,
      'null' => NullFormatter
    }.freeze
  end
end
