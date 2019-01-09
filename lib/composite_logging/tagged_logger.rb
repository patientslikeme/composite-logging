module CompositeLogging
  class TaggedLogger < ::Logger
    def initialize(*args)
      args << { formatter: CompositeLogging::Formatter.new(logger: self) }
      super
      # @default_formatter = CompositeLogging::Formatter.new(logger: self)
    end

    def formatter=(formatter)
      unless formatter.respond_to?(:logger=)
        raise ArgumentError, "Formatter should be a CompositeLogging::Formatter"
      end

      formatter.logger = self
      @formatter = formatter
    end

    def tagged(*tags)
      push_tags(*tags)
      yield self
    ensure
      pop_tags(tags.size)
    end

    def push_tags(*tags)
      tags.concat(tags)
      tags
    end
    alias_method :push_tag, :push_tags

    def pop_tags(count = 1)
      tags.pop(count)
    end
    alias_method :pop_tag, :pop_tags

    def clear_tags
      tags.clear
    end

    def tags
      @tags_key ||= :"composite_logging_tags_#{object_id}"
      Thread.current[@tags_key] ||= []
    end
  end
end
