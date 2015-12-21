require 'open-uri'
require 'json'
require 'csv'

def get_census(district_id, district_name, region_id)
  uri = "http://resultadosgenerales2015.interior.es/senado/results/ES201512-SEN-ES/ES/#{region_id}/#{district_id}/info.json"
  content = open(uri).read
  json = JSON.parse(content)

  puts CSV.generate_line([
      district_id,
      region_id,
      district_name,
      json['results']['census']])
end

# We are going to use the list of provinces plus the islands (used for the Senate)
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

  districts
end

puts CSV.generate_line([
    'province_id',
    'region_id',
    'province',
    'census'])

# In the Senate case, electoral districts are not quite provinces. Almost, but not quite.
get_electoral_districts_list.each do |electoral_district|
  get_census(*electoral_district)
  # sleep 1
end
