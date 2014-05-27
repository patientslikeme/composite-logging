require 'ansi'

module CompositeLogging
  class ColorFormatter < CompositeLogging::Formatter
    include ANSI::Code

    attr_accessor :tag_color, :level_colors

    def initialize(options={})
      super(options)

      self.level_colors = default_level_colors.merge(self.level_colors || {})
      self.tag_color ||= default_tag_color
    end

    def default_format
      "%t [%C%-5s%R] %g%m\n"
    end

    def directives
      @directives ||= super.merge(
        "C" => 'level_colors[severity]',
        "R" => 'reset_color',
      )
    end

    def default_level_colors
      {
        "DEBUG"   => ANSI[:reset, :white],
        "INFO"    => ANSI[:green],
        "WARN"    => ANSI[:yellow],
        "ERROR"   => ANSI[:red],
        "FATAL"   => ANSI[:bright, :red],
        "UNKNOWN" => ANSI[:white],
      }
    end

    def tags_text
      [tag_color, super, reset_color].join
    end

    def default_tag_color
      ANSI[:faint, :white]
    end

    def reset_color
      ANSI[:reset]
    end

  end
end
