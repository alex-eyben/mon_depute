require 'zip'
require 'open-uri'

class ImportVotesJob < ApplicationJob
  queue_as :default

  def perform(quantity)
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/loi/scrutins/Scrutins_XV.json.zip"
    parse_json(@url, quantity)
  end

  def parse_json(url, quantity, votes_num_list = [2039, 2146, 2147])
    file = open(@url)
    Zip::File.open(file) do |zip_file|
      zip_file.first(quantity).each do |entry|
        data = JSON.parse(entry.get_input_stream.read)
        puts JSON.pretty_generate(data["scrutin"]["numero"])
        puts JSON.pretty_generate(data["scrutin"]["dateScrutin"])
        print "contres : "
        puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["contres"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.size)
        print "pours : "
        puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["pours"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.size)
        print "non votants : "
        puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotants"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.size)
        print "abstentions : "
        puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["abstentions"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.size)
        print "non votants volontaires : "
        puts JSON.pretty_generate(data["scrutin"]["ventilationVotes"]["organe"]["groupes"]["groupe"].map{|groupe| groupe = groupe["vote"]}.map{|vote|vote = vote["decompteNominatif"]}.map{|vote| vote = vote["nonVotantsVolontaires"]}.map{|vote| vote = vote["votant"] unless vote.nil?}.flatten.compact.size)
        puts JSON.pretty_generate(data)
      end
      "\o/"
    end
  end
end
