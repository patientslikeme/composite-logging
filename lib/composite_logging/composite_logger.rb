module CompositeLogging
  class CompositeLogger < ::Logger
    attr_accessor :loggers

    def self.build(&block)
      Builder.build(&block)
    end

    def initialize(*loggers)
      super(nil)
      self.loggers = loggers
    end

    def effective_level
      silencer_level || level
    end

    def add(severity, message = nil, progname = nil)
      return true if loggers.none? || severity < effective_level

      # Only evaluate the block once. This code is from the Ruby logger.
      progname ||= @progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end

      loggers.each { |logger| logger.add(severity, message, progname) }

      true
    end

    def <<(msg)
      loggers.each { |logger| logger << msg }
    end

    def close
      loggers.each { |logger| logger.close }
    end

    # Temporary silence the logger by setting its level higher. This method is thread-safe.
    def silence(temporary_level = ::Logger::ERROR)
      self.silencer_level = temporary_level
      old_local_level = silencer_level
      yield self
    ensure
      self.silencer_level = old_local_level
    end

    def tagged(*tags)
      push_tags(*tags)
      yield self
    ensure
      pop_tags(tags.size)
    end

    def push_tags(*tags)
      loggers.each { |logger| logger.push_tags(*tags) }
      tags
    end
    alias_method :push_tag, :push_tags

    def pop_tags(count = 1)
      loggers.each { |logger| logger.pop_tags(count) }
      count
    end
    alias_method :pop_tag, :pop_tags

    def clear_tags
      loggers.each { |logger| logger.clear_tags }
    end

    def tags
      loggers.any? ? loggers.first.tags : []
    end

    protected

    def silencer_key
      @silencer_key ||= :"composite_logging_silencer_level_#{object_id}"
    end

    def silencer_level
      Thread.current[silencer_key]
    end

    def silencer_level=(value)
      Thread.current[silencer_key] = value
    end
  end
end
