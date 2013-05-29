require 'rubygems'
require 'nokogiri'

file = File.open('worksonpaper.xml', 'r')
d=Nokogiri::XML(open(file))
puts d.xpath('//table[@name="MulMultiMediaRef_tab"]').size