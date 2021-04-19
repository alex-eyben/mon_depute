class GetFrondeurStatusJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    @counter = 1
    puts " Done! ----- moyenne de fronde : #{deputies.map{|deputy| deputy = fronding_score(deputy)}.sum/deputies.size}%"
    # is_frondeur?(deputy)
  end

  # def is_frondeur?(deputy)
  #   return 0 if deputy.positions.empty?
  #   total_number_of_same_party_deputies = Deputy.all.where(party: deputy.party).size
  #   fronding_percentage_on_each_vote = deputy.positions.map do |position|
  #     if position.deputy_position == "Pour"
  #       (position.law.positions.where(deputy_position: "Contre").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
  #     elsif position.deputy_position == "Contre"
  #       (position.law.positions.where(deputy_position: "Pour").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
  #     end
  #   end
  #   deputy.update(fronding: (fronding_percentage_on_each_vote.compact.sum / fronding_percentage_on_each_vote.compact.size))
  #   deputy.save
  #   deputy.fronding
  # end
  def fronding_score(deputy)
    @counter += 1
    same_group_different_votes = 0
    if deputy.positions.any?
      deputy.positions.each do |position|
        if position.votant?
          same_group_different_votes += 1 if position.deputy_position != position.deputy_group_position
        end
      end
    deputy.update(fronding: (same_group_different_votes.fdiv(deputy.positions.size)*100).round(0))
    end
    deputy.fronding
  end
end
