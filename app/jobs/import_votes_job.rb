require 'zip'
require 'open-uri'

class ImportVotesJob < ApplicationJob
  queue_as :default

  def perform(quantity = 1)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/loi/scrutins/Scrutins_XV.json.zip"
    parse_json(@url, quantity)
  end

  def parse_json(url, quantity, votes_num_list = ["2039", "2146", "2147"])
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      @zip_file_size = zip_file.size
      zip_file.first(quantity).each_with_index do |entry, i|
        data = JSON.parse(entry.get_input_stream.read)
        if votes_num_list.include?(data["scrutin"]["numero"])
          puts "found one!"
          puts JSON.pretty_generate(data["scrutin"]["numero"])
          puts JSON.pretty_generate(data["scrutin"]["dateScrutin"])
          puts "contres : "
          puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["contres"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          puts "pours : "
          puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["pours"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          puts "non votants : "
          puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotants"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          puts "abstentions : "
          puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["abstentions"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          puts "non votants volontaires : "
          puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotantsVolontaires"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
        end
        print "\r#{100*(i+1)/(@zip_file_size > quantity ? quantity : @zip_file_size)}%     "
        # puts JSON.pretty_generate(data)
        # puts JSON.pretty_generate(get_array_for_votes("pours"))
      end
      puts " =========> Done! :)"
      "\o/"
    end
  end

  # def get_array_for_votes(position)
  #   @data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote[position]}.map{|vote| vote = vote["nonVotantsVolontaires"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact
  # end

  # def parse_json(url, quantity)
  #   file = open(@url)
  #   Zip::File.open(file) do |zip_file|
  #     zip_file.first(quantity).each do |entry|
  #       data = JSON.parse(entry.get_input_stream.read)
  #       yield
  #     end
  #     "\o/"
  #   end
  # end
end
