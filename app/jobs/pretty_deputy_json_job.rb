require 'zip'
require 'open-uri'

class PrettyDeputyJsonJob < ApplicationJob
  queue_as :default

  def perform(quantity)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/amo/deputes_actifs_mandats_actifs_organes/AMO10_deputes_actifs_mandats_actifs_organes_XV.json.zip"
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each do |entry|
        data = JSON.parse(entry.get_input_stream.read)
        puts JSON.pretty_generate(data)
      end
      "youpi"
    end
  end
end
