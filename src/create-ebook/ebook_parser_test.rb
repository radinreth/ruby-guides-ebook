require "minitest/autorun"
require './ebook_parser'

class EbookParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = EbookParser.new "http://www.google.com"
  end

  def test_url_set_properly
    assert_equal @parser.url, "http://www.google.com"
  end
end