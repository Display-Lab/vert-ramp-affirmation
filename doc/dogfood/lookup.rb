#!/usr/bin/env ruby
#
# Read the gocc settings and merge the names with the ids
#   Example of how to collate data into a spek.

require 'json'
require 'pry'

spek_path = "spek.json"
gocc_path = "/home/grosscol/workspace/gocc/config/report_settings.yml"

spek = JSON.parse(File.read(spek_path))
gocc = YAML.load(File.read(gocc_path))

goccd = gocc['default']

clc = goccd['clc']
hbpc = goccd['hbpc']
sites = clc['sites'].merge hbpc['sites']

# Get ref to the performers in the spek
performers = spek['slowmo:has_performer']

# Modify the performer
performers.map do |p|
  id = p['@id'].gsub(/http:.*app#/,'')
  p['name'] = sites[id]['name']
end

# Write modified spek to file
File.open('spek_rev.json',"w") do |f| 
  f.write(JSON.pretty_generate(spek))
  f.flush
end

puts "End of Line."
