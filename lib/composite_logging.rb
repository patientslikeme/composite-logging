require "logger"
require "composite_logging/version"

module CompositeLogging
  autoload :CompositeLogger, "composite_logging/composite_logger"
  autoload :TaggedLogger, "composite_logging/tagged_logger"
  autoload :Formatter, "composite_logging/formatter"
  autoload :ColorFormatter, "composite_logging/color_formatter"

  autoload :Builder, "composite_logging/builder"

  def self.build(logger_class = CompositeLogger, &block)
    Builder.new(logger_class, &block).build
  end
end
