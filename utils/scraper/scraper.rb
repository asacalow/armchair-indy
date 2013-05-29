require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'open-uri'

def get_media_irn(irn)
  begin
    page = Nokogiri::HTML(open("http://www.manchestergalleries.org/the-collections/search-the-collection/display.php?EMUSESSID=b2497961c8d97688b5866cea28950eef&irn=#{irn}")) 
    images = page.css('div#collectionsimage img')
    return "" unless images

    media_irn = nil
    images[0]['src'].gsub(/irn=[0-9]*/) do |match|
      media_irn = match.gsub('irn=','')
    end
    return media_irn || ""
  rescue Exception => e
    puts e.inspect
    return false
  end
end

file = File.open('worksonpaper.xml', 'r')
# file = File.open('worksonpaper-sample.xml', 'r')
out = File.open('irn-map', 'a+')
reader = Nokogiri::XML::Reader(file)
reader.each do |node|
  fragment = Nokogiri::XML.fragment(node.outer_xml)
  next unless fragment.at_xpath('tuple/table[@name="Group1"]')

  irn = fragment.at_xpath(".//atom[@name=\"irn\"]").text
  media_irn = nil
  until media_irn do
    puts "Getting media irn for #{irn}..."
    media_irn = get_media_irn(irn)
  end
  out << "#{irn}: #{media_irn}\n" unless media_irn.empty?
  puts "#{irn}: #{media_irn}"
end
out.close