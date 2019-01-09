require 'test_helper'
require 'ansi'

class FormatterTest < Minitest::Test
  def build_logger(formatter_options={})
    logger = CompositeLogging::TaggedLogger.new(device = StringIO.new)
    logger.formatter = CompositeLogging::Formatter.new(formatter_options)
    [logger, device]
  end

  def test_outputs_severity
    logger, device = build_logger(format: "%s")
    logger.error "Log entry"
    assert_equal "ERROR", device.string
  end

  def test_outputs_timestamp
    logger, device = build_logger(format: "%t", datetime_format: "%F %T")
    logger.error "Log entry"
    assert_match /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\Z/, device.string
  end

  def test_outputs_progname
    logger, device = build_logger(format: "%p")
    logger.progname = "app"
    logger.error "Log entry"
    assert_equal "app", device.string
  end

  def test_outputs_message
    logger, device = build_logger(format: "%m")
    logger.error "Log entry"
    assert_equal "Log entry", device.string
  end

  def test_outputs_tags
    logger, device = build_logger(format: "%g")
    logger.tagged("one") { logger.error "Log entry" }
    assert_equal "[one] ", device.string
  end

  def test_outputs_percent_sign
    logger, device = build_logger(format: "%%")
    logger.error "Log entry"
    assert_equal "%", device.string
  end

  def test_pads_variables
    logger, device = build_logger(format: "[%6s] %-12m\n")
    logger.error "Log entry"
    assert_equal "[ ERROR] Log entry   \n", device.string
  end

  def test_removes_ansi_colors
    logger, device = build_logger(format: "%m\n", decolorize: true)
    logger.error(ANSI.green { "This is green" })
    logger.error(ANSI.red { "This is red" })
    assert_equal "This is green\nThis is red\n", device.string
  end
end
