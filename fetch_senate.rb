require 'open-uri'
require 'json'
require 'csv'

def get_electoral_district_results(district_id, district_name, region_id)
  uri = "http://resultadosgenerales2015.interior.es/senado/results/ES201512-SEN-ES/ES/#{region_id}/#{district_id}/info.json"
  content = open(uri).read
  json = JSON.parse(content)

  json['results']['parties'].each do |party|
    puts CSV.generate_line([
        district_id,
        region_id,
        district_name,
        party['id'],
        party['acronym'],
        party['name'],
        party['votes']['presential'],
        party['seats'],
        json['results']['countedPercent']])
  end
end

def get_electoral_districts_list
  # We start with the provinces
  uri = 'http://resultadosgenerales2015.interior.es/senado/config/ES201512-SEN-ES/provincia.json'
  content = open(uri).read
  districts = JSON.parse(content)

  # Add the islands. (We could calculate this getting 'islas.json', adding 'grupoIslas.json'
  # and removing the individual islands from 'grupoIslas', but, geez...)
  island_districts = [
      ["07A","Eivissa-Formentera","CA04/07"],
      ["073","Mallorca","CA04/07"],
      ["074","Menorca","CA04/07"],
      ["351","Fuerteventura","CA05/35"],
      ["352","Gran Canaria","CA05/35"],
      ["353","Lanzarote","CA05/35"],
      ["381","La Gomera","CA05/38"],
      ["382","El Hierro","CA05/38"],
      ["383","La Palma","CA05/38"],
      ["384","Tenerife","CA05/38"]]
  island_districts_provinces = ["07", "35", "38"]
  districts += island_districts

  # Finally, remove those provinces made up of islands
  districts = districts.find_all {|district| not island_districts_provinces.member? district[0] }

  districts
end

puts CSV.generate_line([
    'province_id',
    'region_id',
    'province',
    'party_id',
    'party_acronym',
    'party_name',
    'votes',
    'seats',
    '% counted'])

# In the Senate case, electoral districts are not quite provinces. Almost, but not quite.
get_electoral_districts_list.each do |electoral_district|
  get_electoral_district_results(*electoral_district)
  sleep 1
end
