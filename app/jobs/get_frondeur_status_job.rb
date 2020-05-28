class GetFrondeurStatusJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    # Do something later
    deputies.map{|deputy| deputy = is_frondeur?(deputy)}
    # is_frondeur?(deputy)
  end

  # def is_frondeur?(deputy)
  #   deputy.laws.each do |law_deputy_voted_on|
  #     law_deputy_voted_on.deputies.where(party: deputy.party).each do |same_party_deputy_on_same_law|

  #     end
  #   end
  # end

  # def is_frondeur?(deputy)
  #   counter = 0
  #   deputy.votes.each do |deputy_vote|
  #     deputy_vote.law.votes.each do |other_vote_on_same_law|
  #       other_vote_on_same_law
  #     end
  #   end
  # end

  def is_frondeur?(deputy)
    # all_pours = Law.first.positions.where(deputy_position: deputy.positions.where(law: law).take.deputy_position )
    # all_pours.select{|position| position.deputy.party == deputy.party}.size
    # number_of_opposite_votes_of_same_party_deputies_for_each_law = Law.all.map{|law| law.positions.where(deputy_position: deputy.positions.where(law: law).take.nil? ? "none" : deputy.positions.where(law: law).take.deputy_position).select{|position| position.deputy.party == deputy.party}.size}

    # deputy_positions = Law.all.map do |law|
    #   deputy.positions.where(law: law).take.nil? ? "none" : deputy.positions.where(law: law).take.deputy_position
    # end
    return 0 if deputy.positions.empty?
    total_number_of_same_party_deputies = Deputy.all.where(party: deputy.party).size
    fronding_percentage_on_each_vote = deputy.positions.map do |position|
      if position.deputy_position == "Pour"
        (position.law.positions.where(deputy_position: "Contre").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
      elsif position.deputy_position == "Contre"
        (position.law.positions.where(deputy_position: "Pour").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
      end
    end
    (fronding_percentage_on_each_vote.compact.sum / fronding_percentage_on_each_vote.compact.size)

    # Law.all.each do |law|
    #   number_of_same_party_same_position_on_one_law = law.positions.where(deputy_position: deputy.positions.where(law: law).take.deputy_position ).select{|position| position.deputy.party == deputy.party}.size
    #   number_of_identical_votes_of_same_party_deputies_for_each_law << number_of_same_party_same_position_on_one_law
    # end
    # mean = number_of_identical_votes_of_same_party_deputies_for_each_law.sum / number_of_identical_votes_of_same_party_deputies_for_each_law.size
    # total = total_number_of_same_party_deputies
    # return (mean.fdiv(total)*100).round(0)
  end
end


#.where(deputy_position = deputy_vote.deputy_position)
