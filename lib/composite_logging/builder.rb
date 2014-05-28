module CompositeLogging
  class Builder

    def initialize(logger_class = CompositeLogging::CompositeLogger, &block)
      @formatter_class = nil
      @formatter_attrs = {}
      @loggers = []
      
      @logger_class = logger_class
      @logger_attrs = {}

      instance_eval(&block)
    end

    def build
      logger_args = @logger_class.ancestors.include?(CompositeLogging::CompositeLogger) ? @loggers : @output_args

      logger = @logger_class.new(*logger_args)
      @logger_attrs.each { |k,v| logger.send("#{k}=", v) }
      logger.formatter = @formatter_class.new(@formatter_attrs) if @formatter_class

      logger
    end

    def logger(logger_class = CompositeLogging::TaggedLogger, &block)
      @loggers << Builder.new(logger_class, &block).build
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
      elsif @logger_class.public_instance_methods.include?(:"#{name}=")
        @logger_attrs[name] = args.first
      else
        super
      end
    end

  end
end
