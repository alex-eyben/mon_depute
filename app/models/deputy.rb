class Deputy < ApplicationRecord
  has_many :positions
  has_many :laws, through: :positions
  acts_as_votable

  def participationRate
    positionsCount = self.positions.count
    absentVotes = self.positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    ((1 - absentCount.fdiv(positionsCount)) * 100).truncate.fdiv(100)
  end

  def frondingRate
    (100 - self.fronding).fdiv(100)
  end

  def yearlyRevenue
    self.yearly_revenue / 1000
  end
end
