$LOAD_PATH.unshift File.expand_path("../lib/cveparser/")
require 'parser'
require 'test/unit'

class TestCveParser < Test::Unit::TestCase
  
  include FIDIUS::NVDParser
  
  def test_should_parse_2_0_only
    assert_raise(RuntimeError) { FIDIUS::NVDParser.parse_cve_file 'test_v2.xml' }
  end
  
  def test_should_find_1_reference
    entries = FIDIUS::NVDParser.parse_cve_file 'test_references.xml'
    assert_equal 1, entries.first.references.size, "The test_references.xml " +
        "contains one reference which should be found."
  end
  
  def test_should_find_3_nvd_entries
    entries = FIDIUS::NVDParser.parse_cve_file 'test_entries.xml'
    assert_equal 3, entries.size, "The test_entries.xml contains 3 NVD " +
        "entries which should be returned in an array."
  end
  
end