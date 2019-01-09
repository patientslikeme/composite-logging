require 'test_helper'

class TaggedLoggerTest < Minitest::Test
  def test_adds_tags_in_a_block
    ENV['DEBUG'] = '1'
    logger = CompositeLogging::TaggedLogger.new(StringIO.new)
    logger.tagged('one') do
      assert_equal ['one'], logger.tags
      logger.tagged('two') do
        assert_equal %w[one two], logger.tags
      end
    end
    logger.tagged('three', 'four') do
      assert_equal %w[three four], logger.tags
    end
    assert_equal [], logger.tags
    ENV['DEBUG'] = nil
  end

  def test_pushes_and_pops_tags
    logger = CompositeLogging::TaggedLogger.new(StringIO.new)
    logger.push_tag('one')
    assert_equal ['one'], logger.tags
    logger.pop_tag
    assert_equal [], logger.tags

    logger.push_tags('two', 'three', 'four')
    assert_equal %w[two three four], logger.tags
    logger.pop_tags(2)
    assert_equal %w[two], logger.tags
    logger.clear_tags
    assert_equal [], logger.tags
  end

  def test_writes_the_tags_to_the_log
    device = StringIO.new
    logger = CompositeLogging::TaggedLogger.new(device)
    logger.formatter = CompositeLogging::Formatter.new(format: '%g%m')

    logger.push_tags('one', 'two')
    logger.info 'Log entry'

    assert_equal '[one] [two] Log entry', device.string
  end
end
