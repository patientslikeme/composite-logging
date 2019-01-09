require 'test_helper'
require 'ansi'

class ColorFormatterTest < Minitest::Test
  def build_logger(formatter_options = {})
    logger = CompositeLogging::TaggedLogger.new(device = StringIO.new)
    logger.formatter = CompositeLogging::ColorFormatter.new(formatter_options)
    [logger, device]
  end

  ANSI_CODE = /\e\[(\d+)(;(\d+))*m/.freeze
  ANSI_RESET = /\e\[0m/.freeze

  def ansi_regexp(ansi_code)
    ansi_code.gsub("\e[", '\e\[')
  end

  def test_colors_tags_by_default
    logger, device = build_logger
    logger.tagged("one") { logger.error "Log entry" }

    assert_match(/#{ANSI_CODE}\s*\[one\]\s*#{ANSI_CODE}/x, device.string)
  end

  def test_changes_tag_color
    logger, device = build_logger(tag_color: ANSI[:yellow])
    logger.tagged("one") { logger.error "Log entry" }

    assert_match(/#{ansi_regexp ANSI[:yellow]}\s*\[one\]\s*#{ANSI_RESET}/, device.string)
  end

  def test_colors_severities_by_default
    [:debug, :info, :warn, :error, :fatal].each do |level|
      logger, device = build_logger
      logger.send(level, "Log entry")

      assert_match(/\[#{ANSI_CODE}#{level}\s*#{ANSI_CODE}\]/i, device.string)
    end
  end

  def test_changes_severity_color
    logger, device = build_logger(level_colors: { "INFO" => ANSI[:red] })
    logger.info "Log entry"

    assert_match(/#{ansi_regexp ANSI[:red]}INFO\s*#{ANSI_RESET}/, device.string)
  end
end
