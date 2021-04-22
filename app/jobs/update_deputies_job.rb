require 'zip'
require 'open-uri'
require 'nokogiri'

class UpdateDeputiesJob < ApplicationJob
  queue_as :default

  def perform(quantity = 1500)
    deputy_uids = []
    @file = open("http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip")
    @parties = import_parties(quantity + 577)
    Zip::File.open(@file) do |zip_file|
      zip_file.each_with_index do |entry, index|
        if entry.name.include?("acteur")
          data = JSON.parse(entry.get_input_stream.read)
          deputy_uids << data["acteur"]["uid"]["#text"]
          deputy = Deputy.find_by(uid: "#{data["acteur"]["uid"]["#text"]}")
          if deputy
            puts "Deputy already exists"
          else 
            new_deputy = {}
            ## p data["acteur"]["uid"]["@xsi:type"]
            new_deputy[:uid] = data["acteur"]["uid"]["#text"] # if we want to add uid to deputy table we can get it here
            new_deputy[:first_name] = data["acteur"]["etatCivil"]["ident"]["prenom"]
            new_deputy[:last_name] = data["acteur"]["etatCivil"]["ident"]["nom"]
            new_deputy[:birth_date] = data["acteur"]["etatCivil"]["infoNaissance"]["dateNais"].to_date
            # deputy[:birth_infos] = data["acteur"]["etatCivil"]["infoNaissance"] # maybe would be better to use this (hash with key values for birth date / city / dep / country) instead of birth_date + birth_place.
            new_deputy[:birth_place] = data['acteur']['etatCivil']['infoNaissance']['villeNais']
            # deputy[:adresses_elec] = data['acteur']['adresses']['adresse'][1..-1].map{|address| address = { address["typeLibelle"] => address["valElec"]} } # Maybe better to store this (array of all addresses) instead of having multi columns with each address
            ## deputy[:other_adresses] = data["acteur"]["adresses"]["adresse"].reject{|address|address["typeLibelle"]=="Mèl"} # Can use this one to store email in own column then all other adresses in an array
            elec_addresses = {}
            # if data['acteur']['adresses']['adresse'].class == Array
            #   data['acteur']['adresses']['adresse'][1..-1].each{|address| elec_addresses[address["typeLibelle"]] = address["valElec"] }
            # else
            [data['acteur']['adresses']['adresse']].flatten(1)[1..-1].each{|address| elec_addresses[address["typeLibelle"]] = address["valElec"] }
            # end
            new_deputy[:email] = elec_addresses.has_key?("Mèl") ? elec_addresses["Mèl"] : "N/A"
            new_deputy[:twitter] = elec_addresses.has_key?("Twitter") ? elec_addresses["Twitter"] : "N/A"
            new_deputy[:facebook] = elec_addresses.has_key?("Facebook") ? elec_addresses["Facebook"] : "N/A"
            new_deputy[:website] = elec_addresses.has_key?("Site internet") ? elec_addresses["Site internet"] : "N/A"
            new_deputy[:job] = data['acteur']['profession']["libelleCourant"]
            new_deputy[:revenue] = data['acteur']["uri_hatvp"] # todo: scrape hatvp
            new_deputy[:yearly_revenue] = GetDeputyRevenueJob.perform_now(data['acteur']["uri_hatvp"])
            new_deputy[:party] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["typeOrgane"]=="PARPOL"}.empty? ? "Parti non renseigné" : @parties[data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["typeOrgane"]=="PARPOL"}.first["organes"]["organeRef"]]
            new_deputy[:circonscription] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["election"]["lieu"]["numCirco"]
            new_deputy[:department] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["election"]["lieu"]["numDepartement"]
            new_deputy[:img] = "https://www2.assemblee-nationale.fr/static/tribun/15/photos/#{data['acteur']['uid']['#text'][2..-1]}.jpg"
            new_deputy[:entry_date] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["mandature"]["datePriseFonction"]
            Deputy.create!(new_deputy)
          end
        end
      end
      # puts JSON.pretty_generate(deputies) # useful for debug
    end
    # Delete all deputies that are not at the Assemblée anymore
    Deputy.all.each do |deputy|
      if deputy_uids.index(deputy.uid).nil?
        deputy.positions.each do |position|
          position.delete
        end
        deputy.delete
      end
    end
  end

  def import_parties(quantity)
    puts "import_parties is starting up"
    # quantity += 577
    parties = {}
    Zip::File.open(@file) do |zip_file|
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
end
