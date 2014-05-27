require 'test_helper'

class TaggedLoggerTest < Minitest::Test

  def build_basic_logger
    logger = CompositeLogging::TaggedLogger.new(device = StringIO.new)
    logger.formatter = CompositeLogging::Formatter.new(format: "%m\n")
    [logger, device]
  end

  def build_basic_composite
    @child_1, @device_1 = build_basic_logger
    @child_2, @device_2 = build_basic_logger
    @logger = CompositeLogging::CompositeLogger.new(@child_1, @child_2)
    @logger.level = Logger::DEBUG
    @logger
  end

  def test_writes_to_all_logs
    build_basic_composite
    @logger.info "Log entry"
    assert_equal "Log entry\n", @device_1.string
    assert_equal "Log entry\n", @device_2.string
  end

  def test_applies_level_to_all_loggers
    build_basic_composite

    @logger.level = Logger::INFO
    @logger.debug "Debug entry 1"
    assert_equal "", @device_1.string
    assert_equal "", @device_2.string

    @logger.level = Logger::DEBUG
    @logger.debug "Debug entry 2"
    assert_equal "Debug entry 2\n", @device_1.string
    assert_equal "Debug entry 2\n", @device_2.string
  end

  def test_silences_all_loggers
    build_basic_composite

    @logger.debug "Before silencing"
    @logger.silence do
      @logger.debug "Silenced entry"
    end
    @logger.debug "After silencing"

    assert_equal "Before silencing\nAfter silencing\n", @device_1.string
    assert_equal "Before silencing\nAfter silencing\n", @device_2.string
  end

  def test_applies_tagged_blocks_to_all_loggers
    build_basic_composite
    @logger.loggers.each { |l| l.formatter.format = "%g%m\n" }

    @logger.tagged("one", "two") do
      @logger.debug "I see tags"
    end

    assert_equal "[one] [two] I see tags\n", @device_1.string
    assert_equal "[one] [two] I see tags\n", @device_2.string
  end

  def test_applies_pushed_tags_to_all_loggers
    build_basic_composite
    @logger.loggers.each { |l| l.formatter.format = "%g%m\n" }

    @logger.push_tag("one")
    @logger.debug "One tag"
    @logger.pop_tag
    @logger.debug "No tags"

    assert_equal "[one] One tag\nNo tags\n", @device_1.string
    assert_equal "[one] One tag\nNo tags\n", @device_2.string
  end

end
