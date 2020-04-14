require_relative 'test_helper'
include ServerScripts

class TestCubex < Minitest::Test
  parser = Parser::Cubex.new("test/artifacts/cubex")
  puts parser.parse(counter: "PAPI_L3_TCM", event: "gemv")
end
