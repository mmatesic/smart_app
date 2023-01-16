#!/usr/bin/ruby

require './lib/parser.rb'

unless ARGV[0]
    puts "Usage: ruby parser.rb <filename.log>"
    puts "Example: ruby parser.rb webserver.log>"
    exit
end

parser = Parser.new
parser.read_file(ARGV[0].chomp)
parser.report_visits_count
puts "---------------------------------------------------"
parser.report_unique_visits_count
