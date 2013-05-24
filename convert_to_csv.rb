require 'rubygems'
require 'nokogiri'
require 'csv'

FIELDS = {
  'IRN' => 'irn',
  'Name' => 'NamFullName',
  'Role' => 'CreRole',
  'Summary' => 'SummaryData',
  'Creation Date' => 'CreDateCreated',
  'Creation Date (earliest)' => 'CreEarliestDate',
  'Creation Date (latest)' => 'CreLatestDate',
  'Title' => 'TitMainTitle',
  'Format' => 'TitObjectName',
  'Medium' => 'PhyMedium',
  'Support' => 'PhySupport',
  'Technique' => 'PhyTechnique',
  'Description' => 'PhyDescription',
  'Height' => 'PhyHeight',
  'Width' => 'PhyWidth',
  'Unit' => 'PhyUnitLength',
  'Inscription' => 'CrePrimaryInscriptions'
}

file = File.open('worksonpaper.xml', 'r')
# file = File.open('worksonpaper-minimal.xml', 'r')
CSV.open("out.csv", "w") do |csv|
  csv << FIELDS.keys
  reader = Nokogiri::XML::Reader(file)
  reader.each do |node|
    fragment = Nokogiri::XML.fragment(node.outer_xml)
    next unless fragment.at_xpath('tuple/table[@name="Group1"]')
    fields = []
    FIELDS.values.each do |field|
      xpath = ".//atom[@name=\"#{field}\"]"
      value = fragment.at_xpath(xpath).text rescue ''
      fields << value
    end
    csv << fields
  end
end