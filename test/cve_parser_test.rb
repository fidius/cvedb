$LOAD_PATH.unshift File.expand_path("../lib/cveparser/")
require 'parser'
require 'test/unit'

class TestCveParser < Test::Unit::TestCase
  
  include FIDIUS::NVDParser
  
  def test_should_parse_2_0_only
    assert_raise(RuntimeError) { FIDIUS::NVDParser.parse_cve_file 'test_v2.xml' }
  end
  
  def test_should_find_2_references
    entries = FIDIUS::NVDParser.parse_cve_file 'test_references.xml'
    puts "------------#{entries.first.inspect}----------------"
    assert_equal 2, entries.first.references.size, "bla"
  end
  
end