require 'ansi'

module CompositeLogging
  class Formatter < ::Logger::Formatter

    attr_accessor :logger, :format, :datetime_format, :decolorize

    def initialize(options={})
      options.each do |k,v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end

      self.format ||= default_format
      self.decolorize = !!decolorize
    end

    def call(severity, time, progname, msg)
      format % replacement_values(severity, time, progname, msg)
    end

    def format=(str)
      # $1 is the "-#.#" match within the directive
      # $2 is the directive letter
      re = /%(-?[\.\d]+)?([#{directives.keys}])/
      replacements = []
      
      @format = str.gsub(re) do |match|
        size, directive = $1, $2
        replacements << directives[directive]
        "%#{size}s"
      end

      instance_eval %{
        def replacement_values(severity, time, progname, msg)
          [ #{replacements.join(', ')} ]
        end
      }
    end

    def default_format
      "%t [%-5s] %g%m\n"
    end

    def directives
      @directives ||= {
        "s" => 'severity',
        "t" => 'format_datetime(time)',
        "p" => 'progname',
        "m" => 'msg2str(msg)',
        "g" => 'tags_text',
        "%" => '"%"',
      }
    end

    protected

    def msg2str(msg)
      decolorize ? ANSI.unansi(super(msg)) : super(msg)
    end

    def tags_text
      if logger && logger.tags.any?
        logger.tags.map{ |t| "[#{t}]" }.join(' ') + " "
      else
        ""
      end
    end

  end
end
