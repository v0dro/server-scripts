require_relative 'test_helper'
include ServerScripts

class TestCubex < Minitest::Test
  parser = Parser::Cubex.new("test/artifacts/cubex")
  puts "---- ALL METRICS -----"
  puts "#{parser.all_metrics}"
  puts "---- ONLY GEMV -----"
  puts parser.parse(metric: "PAPI_L3_TCM", event: "gemv")
  puts "----- CALL TREE -----"
  puts parser.call_tree
end
