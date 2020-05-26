require 'zip'
require 'open-uri'
require 'pry-byebug'
require 'json'

class ImportDeputiesJob < ApplicationJob
  queue_as :default

  def perform(quantity = 1000)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip"
    puts "Off we go"
    @parties = import_parties(1500)
    parse_deputies_files(quantity)
  end

  def import_parties(quantity)
    puts "import_parties is starting up"
    quantity += 577 # the zip_file doesnt recognize folders so we pass deputies here too. adding 577 to quantity insure that if specified quantity is 1 we get 1 organ and not 1 deputy. alright this is not very clear sorry.
    parties = {}
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each_with_index do |entry, index|
          if entry.name.include?("organe")
            data = JSON.parse(entry.get_input_stream.read)
            if data["organe"]["codeType"] == "PARPOL" # we keep only the PARPOL aka political parties for the moment
              parties["#{data["organe"]["uid"]}"] = data["organe"]["libelleEdition"] # I went with easy way key-value where key = uid and value = party name
            end
          end
      end
      puts JSON.pretty_generate(parties)
      puts "All OK ===> in parties"
      return parties
    end
  end

  def parse_deputies_files(quantity)
    deputies = []
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each_with_index do |entry, index|
        if entry.name.include?("acteur")
          data = JSON.parse(entry.get_input_stream.read)
          # puts JSON.pretty_generate(data["acteur"]) # I use this to display json Nicely so I'm able to find routes
          deputy = {}
          ## p data["acteur"]["uid"]["@xsi:type"]
          ## p data["acteur"]["uid"]["#text"] # if we want to add uid to deputy table we can get it here
          deputy[:first_name] = data["acteur"]["etatCivil"]["ident"]["prenom"]
          deputy[:last_name] = data["acteur"]["etatCivil"]["ident"]["nom"]
          deputy[:birth_date] = data["acteur"]["etatCivil"]["infoNaissance"]["dateNais"].to_date
          # deputy[:birth_infos] = data["acteur"]["etatCivil"]["infoNaissance"] # maybe would be better to use this (hash with key values for birth date / city / dep / country) instead of birth_date + birth_place.
          deputy[:birth_place] = data['acteur']['etatCivil']['infoNaissance']['villeNais']
          # deputy[:adresses_elec] = data['acteur']['adresses']['adresse'][1..-1].map{|address| address = { address["typeLibelle"] => address["valElec"]} } # Maybe better to store this (array of all addresses) instead of having multi columns with each address
          ## deputy[:other_adresses] = data["acteur"]["adresses"]["adresse"].reject{|address|address["typeLibelle"]=="Mèl"} # Can use this one to store email in own column then all other adresses in an array
          elec_addresses = {}
          data['acteur']['adresses']['adresse'][1..-1].each{|address| elec_addresses[address["typeLibelle"]] = address["valElec"] }
          deputy[:email] = elec_addresses.has_key?("Mèl") ? elec_addresses["Mèl"] : "N/A"
          deputy[:twitter] = elec_addresses.has_key?("Twitter") ? elec_addresses["Twitter"] : "N/A"
          deputy[:facebook] = elec_addresses.has_key?("Facebook") ? elec_addresses["Facebook"] : "N/A"
          deputy[:website] = elec_addresses.has_key?("Site internet") ? elec_addresses["Site internet"] : "N/A"
          deputy[:job] = data['acteur']['profession']["libelleCourant"]
          deputy[:revenue] = data['acteur']["uri_hatvp"] # todo: scrape hatvp
          deputy[:party] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["typeOrgane"]=="PARPOL"}.empty? ? "N/A" : @parties[data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["typeOrgane"]=="PARPOL"}.first["organes"]["organeRef"]]
          deputy[:circonscription] = [data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["election"]["lieu"]["numDepartement"], data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["election"]["lieu"]["numCirco"]]
          deputies << deputy
          p "INDEX : #{index} -------------------------------------------------------------------------"
        end
      end
      puts JSON.pretty_generate(deputies)
      puts "All OK ===> in deputies"
      puts "number of deputies : #{deputies.size}"
      return deputies
    end
  end

end
