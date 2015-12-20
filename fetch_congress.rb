require 'open-uri'
require 'json'
require 'csv'

def get_province_results(province_id, province_name, region_id)
  uri = "http://resultadosgenerales2015.interior.es/congreso/results/ES201512-CON-ES/ES/#{region_id}/#{province_id}/info.json"
  content = open(uri).read
  json = JSON.parse(content)

  json['results']['parties'].each do |party|
    puts CSV.generate_line([
        province_id,
        region_id,
        province_name,
        party['id'],
        party['acronym'],
        party['name'],
        party['votes']['presential'],
        party['seats']
      ])
  end
end

def get_province_list
  uri = 'http://resultadosgenerales2015.interior.es/congreso/config/ES201512-CON-ES/provincia.json'
  content = open(uri).read
  return JSON.parse(content)
end

puts CSV.generate_line(['province_id', 'region_id', 'province', 'party_id', 'party_acronym', 'party_name', 'votes', 'seats'])
get_province_list.each do |province|
  get_province_results(*province)
  sleep 1
end
