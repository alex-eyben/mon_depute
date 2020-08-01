require 'zip'
require 'open-uri'
require 'nokogiri'

class AddEntryDateToDeputiesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    file = open("http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip")
    Zip::File.open(file) do |zip_file|
      zip_file.each_with_index do |entry, index|
        if entry.name.include?("acteur")
          data = JSON.parse(entry.get_input_stream.read)
          deputy = Deputy.find_by(uid: "#{data["acteur"]["uid"]["#text"]}")
          if deputy
            deputy.entry_date = data["acteur"]["mandats"]["mandat"].select{|mandat|mandat["organes"]["organeRef"]=="PO717460"}.first["mandature"]["datePriseFonction"]
            deputy.save
          end
        end
      end
      # puts JSON.pretty_generate(deputies) # useful for debug
    end
  end

end
