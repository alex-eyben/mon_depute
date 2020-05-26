require 'zip'
require 'open-uri'
require 'pry-byebug'
require 'json'

class ImportDeputiesJob < ApplicationJob
  queue_as :default

  # def initialize
    # @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip"
  # end

  def perform(quantity)
    puts "coucou"
    test(quantity)
    return "all ok"
  end

  def test(quantity)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip"
    file = open(@url)
    deputies = []
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each do |entry|
        data = JSON.parse(entry.get_input_stream.read)
        # deputy = {}
        # p data["acteur"]["uid"]["@xsi:type"]
        # p data["acteur"]["uid"]["#text"]
        # deputy[:first_name] = data["acteur"]["etatCivil"]["ident"]["prenom"]
        # deputy[:last_name] = data["acteur"]["etatCivil"]["ident"]["nom"]
        # deputy[:birth_date] = data["acteur"]["etatCivil"]["infoNaissance"]["dateNais"].to_datetime
        # puts JSON.pretty_generate(data["acteur"]["etatCivil"])
        deputies << data["acteur"]["mandats"]["mandat"][-1]["election"]["refCirconscription"]
        # p deputy
      end
      p deputies.size
      p deputies.uniq.size
      puts deputies.size == deputies.uniq.size
    end
  end

end


# amadou = { first_name: "Aude", last_name: "Amadou", email: "aude.amadou@assemblee-nationale.fr", job: "Ex-sportive de haut niveau", birth_place: "Coutances", birth_date: Time.now.to_datetime, party: "LREM", twitter: "https://twitter.com/AudeAmadou", facebook: "AmadouAude", website: "www.aude-amadou.info", revenue: 45000, circonscription: 4 }
