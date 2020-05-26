require 'zip'
require 'open-uri'
require 'pry-byebug'
require 'json'

class ImportDeputiesJob < ApplicationJob
  queue_as :default

  def perform(quantity)
    puts "coucou"
    parse_deputies_files(quantity).class
  end

  def parse_deputies_files(quantity)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip"
    file = open(@url)
    deputies = []
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each_with_index do |entry, index|
        data = JSON.parse(entry.get_input_stream.read)
        deputy = {}
        ## p data["acteur"]["uid"]["@xsi:type"]
        ## p data["acteur"]["uid"]["#text"]
        deputy[:first_name] = data["acteur"]["etatCivil"]["ident"]["prenom"]
        deputy[:last_name] = data["acteur"]["etatCivil"]["ident"]["nom"]
        deputy[:birth_date] = data["acteur"]["etatCivil"]["infoNaissance"]["dateNais"].to_date
        # deputy[:birth_infos] = data["acteur"]["etatCivil"]["infoNaissance"]
        deputy[:birth_place] = data['acteur']['etatCivil']['infoNaissance']['villeNais']
        deputy[:email] = data["acteur"]["adresses"]["adresse"].select{|address|address["typeLibelle"]=="Mèl"}.first["valElec"]
        # deputy[:adresses_elec] = data['acteur']['adresses']['adresse'][1..-1].map{|address| address = { address["typeLibelle"] => address["valElec"]} }
        ## deputy[:other_adresses] = data["acteur"]["adresses"]["adresse"].reject{|address|address["typeLibelle"]=="Mèl"}
        deputy[:job] = data['acteur']['profession']["libelleCourant"]
        deputy[:revenue] = data['acteur']["uri_hatvp"]
        deputy[:party] = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["typeOrgane"]=="PARPOL"}.first["uid"]
        deputy[:circonscription] = [data["acteur"]["mandats"]["mandat"].last["election"]["lieu"]["numDepartement"], data["acteur"]["mandats"]["mandat"].last["election"]["lieu"]["numCirco"]]
        ## puts JSON.pretty_generate(data["acteur"]["mandats"]["mandat"].last["election"]["lieu"])
        deputies << deputy
        ## p deputy
        p "INDEX : #{index}"
      end
      puts JSON.pretty_generate(deputies)
      # p deputies.size
      # p deputies.uniq.size
      # puts deputies.size == deputies.uniq.size
      puts "All OK"
      return deputies
    end
  end

end
