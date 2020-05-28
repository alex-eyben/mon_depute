require 'zip'
require 'open-uri'

class ImportVotesJob < ApplicationJob
  queue_as :default

  def perform(quantity = 1000, scrutin_id_array = ["2039", "138", "2065"])
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/loi/scrutins/Scrutins_XV.json.zip"
    parse_json(@url, quantity, scrutin_id_array)
  end

  def parse_json(url, quantity, scrutin_id_array)
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      zip_file_size = zip_file.size
      zip_file.first(quantity).each_with_index do |entry, i|
        data = JSON.parse(entry.get_input_stream.read)
        if scrutin_id_array.map{|scrutin_id|scrutin_id = scrutin_id.to_s}.include?(data["scrutin"]["numero"])
          puts "found one!"
          puts JSON.pretty_generate(data["scrutin"]["numero"])
          puts JSON.pretty_generate(data["scrutin"]["dateScrutin"])
          puts "creating contres..."
          # puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["contres"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          deputies_contres = data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["contres"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]}
          deputies_contres.each{|deputy_contre| Position.create!(deputy_position: "Contre", deputy: Deputy.where(uid: deputy_contre).first, law: Law.where(scrutin_id: data["scrutin"]["numero"]).first ) unless Deputy.where(uid: deputy_contre).empty?}
          puts "creating pours..."
          # puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["pours"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          deputies_pours = data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["pours"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]}
          deputies_pours.each{|deputy_pour| Position.create!(deputy_position: "Pour", deputy: Deputy.where(uid: deputy_pour).first, law: Law.where(scrutin_id: data["scrutin"]["numero"]).first )  unless Deputy.where(uid: deputy_pour).empty?}
          puts "creating non votants..."
          # puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotants"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          deputies_nonVotants = data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotants"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]}
          deputies_nonVotants.each{|deputy_nonVotant| Position.create!(deputy_position: "Non votant", deputy: Deputy.where(uid: deputy_nonVotant).first, law: Law.where(scrutin_id: data["scrutin"]["numero"]).first ) unless Deputy.where(uid: deputy_nonVotant).empty?}
          puts "creating abstentions..."
          # puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["abstentions"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          deputies_abstentions = data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["abstentions"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]}
          deputies_abstentions.each{|deputy_abstention| Position.create!(deputy_position: "Abstention", deputy: Deputy.where(uid: deputy_abstention).first, law: Law.where(scrutin_id: data["scrutin"]["numero"]).first ) unless Deputy.where(uid: deputy_abstention).empty?}
          puts "creating non votants volontaires..."
          # puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotantsVolontaires"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]})
          deputies_nonVotantsVolontaires = data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotantsVolontaires"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.map{|acteur| acteur = acteur["acteurRef"]}
          deputies_nonVotantsVolontaires.each{|deputy_nonVotantVolontaire| Position.create!(deputy_position: "Non votant volontaire", deputy: Deputy.where(uid: deputy_nonVotantVolontaire).first, law: Law.where(scrutin_id: data["scrutin"]["numero"]).first ) unless Deputy.where(uid: deputy_nonVotantVolontaire).empty?}
        end
        print "\r#{100*(i+1)/(zip_file_size > quantity ? quantity : zip_file_size)}%     "
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
