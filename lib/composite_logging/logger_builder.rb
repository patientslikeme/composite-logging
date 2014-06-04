module CompositeLogging
  class LoggerBuilder

    def initialize(logger_class = TaggedLogger, &block)
      @logger_class = logger_class
      @formatter_attrs = {}

      instance_eval(&block)
    end

    def build
      logger = @logger_class.new(*@output_args)
      logger.formatter = @formatter_class.new(@formatter_attrs) if @formatter_class
      logger
    end

    def output(*args)
      @output_args = args
    end

    def formatter(formatter_class)
      @formatter_class = formatter_class
    end

    def method_missing(name, *args, &block)
      if @formatter_class && @formatter_class.public_instance_methods.include?(:"#{name}=")
        @formatter_attrs[name] = args.first
      else
        super
      end
    end

  end
end
