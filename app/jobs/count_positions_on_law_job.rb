require 'zip'
require 'open-uri'

class CountPositionsOnLawJob < ApplicationJob
  queue_as :default

  def perform(law)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/loi/scrutins/Scrutins_XV.json.zip"
    file = open(@url)
    attr = {file: file, scrutins: law.scrutin_id}
    Zip::File.open(attr[:file]) do |zip_file|
      zip_file.each do |entry|
        if entry.name == "json/VTANR5L15V" + "#{law.scrutin_id}" + ".json" 
          data = JSON.parse(entry.get_input_stream.read)["scrutin"]["syntheseVote"]["decompte"]
          law.pour = data["pour"]
          law.contre = data["contre"]
          law.abstenu = data["abstentions"]
        end
      end
    end
    law.save
  end
end
