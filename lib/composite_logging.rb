require "logger"
require "composite_logging/version"

module CompositeLogging
  autoload :CompositeLogger, "composite_logging/composite_logger"
  autoload :TaggedLogger, "composite_logging/tagged_logger"
  autoload :Formatter, "composite_logging/formatter"
  autoload :ColorFormatter, "composite_logging/color_formatter"

  autoload :CompositeLoggerBuilder, "composite_logging/composite_logger_builder"
  autoload :LoggerBuilder, "composite_logging/logger_builder"

  def self.build(&block)
    CompositeLoggerBuilder.new(&block).build
  end
end
