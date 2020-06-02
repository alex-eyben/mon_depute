class Deputy < ApplicationRecord
  has_many :positions
  has_many :laws, through: :positions
  acts_as_votable

  # def frondeur
  #   same_group_different_votes = 0
  #   self.positions.each do |position|
  #     if position.votant?
  #       same_group_different_votes += 1 if ((position.deputy_position == "pour" &&  position.deputy_group_position == "contre") || (position.deputy_position == "contre" &&  position.deputy_group_position == "pour"))
  #     end
  #   end
  #   (same_group_different_votes.fdiv(self.positions.size)*100).round(0)
  # end
end
