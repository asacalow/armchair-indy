require 'rubygems'
require 'bundler'
Bundler.require(:default)
require './elasticsearch'
require 'yaml'

FIELDS = {
  irn: 'irn',
  creator: 'NamFullName',
  role: 'CreRole',
  summary: 'SummaryData',
  created_on: 'CreDateCreated',
  earliest_created_on: 'CreEarliestDate',
  latest_created_on: 'CreLatestDate',
  title: 'TitMainTitle',
  format: 'TitObjectName',
  medium: 'PhyMedium',
  support: 'PhySupport',
  technique: 'PhyTechnique',
  description: 'PhyDescription',
  height: 'PhyHeight',
  width: 'PhyWidth',
  unit: 'PhyUnitLength',
  inscription: 'CrePrimaryInscriptions'
}

CollectionItem.index.delete

media_irns = YAML.load(open('irn-map.yml'))

file = File.open('worksonpaper.xml', 'r')
# file = File.open('worksonpaper-minimal.xml', 'r')
reader = Nokogiri::XML::Reader(file)
reader.each do |node|
  fragment = Nokogiri::XML.fragment(node.outer_xml)
  next unless fragment.at_xpath('tuple/table[@name="Group1"]')
  attrs = {}
  FIELDS.each do |field, attr|
    xpath = ".//atom[@name=\"#{attr}\"]"
    value = fragment.at_xpath(xpath).text rescue ''
    attrs[field] = value
  end

  irn = attrs[:irn].to_i
  media_irn = media_irns[irn]
  attrs[:media_irn] = media_irn if media_irn
  attrs[:media_irn] ||= fragment.at_xpath('.//table[@name="MulMultiMediaRef_tab"]/tuple/atom[@name="irn"]').text rescue nil

  item = CollectionItem.create(attrs)
  puts "Imported '#{item.title}' by #{item.creator}"
end