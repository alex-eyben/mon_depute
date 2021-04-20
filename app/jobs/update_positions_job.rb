require 'zip'
require 'open-uri'

class UpdatePositionsJob < ApplicationJob
  queue_as :default

  def perform(scrutin_id_array = [2039]) #"2039", "138", "2065"
    @counter = 0
    @total = scrutin_id_array.size*Deputy.all.size
    @url = "http://data.assemblee-nationale.fr/static/openData/repository/15/loi/scrutins/Scrutins_XV.json.zip"
    file = open(@url)
    attr = {file: file, scrutins: scrutin_id_array}
    create_positions(attr)
    GetFrondeurStatusJob.perform_now
    GetPresenceScoreJob.perform_now
    puts "-------computed!"
  end

  def create_positions(attr)
    # attr[scrutins][0]
    Zip::File.open(attr[:file]) do |zip_file|
      zip_file_size = zip_file.size
      zip_file.each_with_index do |entry, i|
        data = JSON.parse(entry.get_input_stream.read)
        current_scrutin = get_scrutin_num(data)
        if attr[:scrutins].map{|scrutin_id|scrutin_id = scrutin_id.to_s}.include?(current_scrutin)
          # puts JSON.pretty_generate(data)
          # puts get_scrutin_date(data)
          @scrutin_date = get_scrutin_date(data)
          @scrutin_maj_position = get_scrutin_maj_position(data)
          groupes_array = get_groupes(data)
          # puts JSON.pretty_generate(groupes_array)
          create_deputies_positions(groupes_array, current_scrutin)
          set_absent_to_others(current_scrutin)
          # print "\r#{100*(i+1)/(zip_file_size > attr[:quantity] ? attr[:quantity] : zip_file_size)}%     "
        end
        # print "\r#{100*(i+1)/(zip_file_size > attr[:quantity] ? attr[:quantity] : zip_file_size)}%     "
      end
      puts " =========> Done! :)"
      "\o/"
    end
  end

  def get_scrutin_num(data)
    data["scrutin"]["numero"]
  end

  def get_scrutin_date(data)
    data["scrutin"]["dateScrutin"]
  end

  def get_scrutin_maj_position(data)
    first_position = ""
    max_value = 0
    data['scrutin']['syntheseVote']['decompte'].each_pair do |key,value|
      if value.to_i > max_value
        max_value = value.to_i
        first_position = key
      end
    end
    first_position
  end

  def get_groupes(data)
    data["scrutin"]['ventilationVotes']['organe']['groupes']['groupe']
  end

  def create_deputies_positions(groupes_array, current_scrutin)
    groupes_array.each do |groupe|
      groupe['vote']['decompteNominatif'].each_key do |key|
        unless groupe['vote']['decompteNominatif'][key].nil?
          [groupe['vote']['decompteNominatif'][key]['votant']].flatten.each do |votant|
            vote_position_cause = votant['causePositionVote'] if key == "nonVotants"
            deputy_group_position = groupe["vote"]["positionMajoritaire"]
            Position.create!( deputy_position: key[0..-2],
                              date: @scrutin_date.to_date,
                              deputy: Deputy.where(uid: votant['acteurRef']).take,
                              law: Law.where(scrutin_id: current_scrutin).take,
                              vote_position_cause: vote_position_cause,
                              deputy_group_position: deputy_group_position,
                              majority: @scrutin_maj_position,
                              votant: true
                            ) unless Deputy.where(uid: votant['acteurRef']).empty? || Deputy.find_by(uid: votant['acteurRef']).positions.any?
            # print "position for #{Position.last.deputy.last_name} created - "
            print "\r#{((@counter.fdiv(@total))*100).round(2)}%"
            @counter += 1
          end
        end
      end
    end
  end

  def set_absent_to_others(current_scrutin)
    Deputy.all.reject{|deputy|deputy.laws.map{|law|law=law.scrutin_id}.include?(current_scrutin.to_i)}.each{|deputy|Position.create!(deputy: deputy, law: Law.where(scrutin_id: current_scrutin).take, date: @scrutin_date.to_date, votant: false )}
    print "\r#{((@counter.fdiv(@total))*100).round(2)}%"
    @counter += 1
  end
end
