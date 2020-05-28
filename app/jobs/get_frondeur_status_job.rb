class GetFrondeurStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end

  # def is_frondeur?(deputy)
  #   deputy.laws.each do |law_deputy_voted_on|
  #     law_deputy_voted_on.deputies.where(party: deputy.party).each do |same_party_deputy_on_same_law|

  #     end
  #   end
  # end

  def is_frondeur?(deputy)
    counter = 0
    deputy.votes.each do |deputy_vote|
      deputy_vote.law.votes.each do |other_vote_on_same_law|
        other_vote_on_same_law
      end
    end
  end
end


#.where(deputy_position = deputy_vote.deputy_position)
