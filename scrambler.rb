#!/usr/bin/env ruby

=begin

Scrambler
Scans my inspir directory, loads all filepaths, scrambles them,
and dumps out an html file for viewing them.

=end

require "rubygems"
require "haml"

IGNORE = [ ".", "..", ".DS_Store" ]

inspirpath = ARGV[0] ? ARGV[0] : "~/Pictures/inspir/"
outputFile = ARGV[1] ? ARGV[1] : "index.html"

engine = Haml::Engine.new(File.read("index.html.haml"))
html = File.new(outputFile, "w")

# Switch to proper dir
Dir.chdir(File.expand_path(inspirpath))


def scan(path)
	filenames = Array.new
	Dir.entries(path).each do |filename|
		if !IGNORE.include? filename
			if File.directory? File.expand_path(path + "/" + filename)
				filenames.push(* scan( path + "/" + filename ))
			else
				filenames << File.expand_path(path) + "/" + filename
			end
		end
	end
	return filenames
end

filenames = scan(".")
filenames.shuffle!

output = engine.render(Object.new, :filenames => filenames)
html.puts output
html.close
