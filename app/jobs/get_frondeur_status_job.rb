class GetFrondeurStatusJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    "moyenne de fronde : #{deputies.map{|deputy| deputy = is_frondeur?(deputy)}.sum/deputies.size}%"
    # is_frondeur?(deputy)
  end

  def is_frondeur?(deputy)
    return 0 if deputy.positions.empty?
    total_number_of_same_party_deputies = Deputy.all.where(party: deputy.party).size
    fronding_percentage_on_each_vote = deputy.positions.map do |position|
      if position.deputy_position == "Pour"
        (position.law.positions.where(deputy_position: "Contre").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
      elsif position.deputy_position == "Contre"
        (position.law.positions.where(deputy_position: "Pour").select{|position|position.deputy.party == deputy.party}.size.fdiv(total_number_of_same_party_deputies)*100).round(0)
      end
    end
    deputy.update(fronding: (fronding_percentage_on_each_vote.compact.sum / fronding_percentage_on_each_vote.compact.size))
    deputy.save
    deputy.fronding
  end
end
