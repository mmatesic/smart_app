#!/usr/bin/ruby

require './lib/parser.rb'

parser = Parser.new
parser.read_file(ARGV[0])
parser.report_visits_count
puts "---------------------------------------------------"
parser.report_unique_visits_count
