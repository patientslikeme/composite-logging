module CompositeLogging
  class CompositeLoggerBuilder

    def initialize(&block)
      @loggers = []
      @logger_class = logger_class
      @logger_attrs = {}

      instance_eval(&block)
    end

    def build
      logger = @logger_class.new(*@loggers)
      @logger_attrs.each { |k,v| logger.send("#{k}=", v) }
      logger
    end

    def logger(logger_class = CompositeLogging::TaggedLogger, &block)
      @loggers << LoggerBuilder.new(logger_class, &block).build
    end

    def method_missing(name, *args, &block)
      if @logger_class.public_instance_methods.include?(:"#{name}=")
        @logger_attrs[name] = args.first
      else
        super
      end
    end

  end
end
