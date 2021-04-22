class Deputy < ApplicationRecord
  has_many :positions, dependent: :destroy
  has_many :laws, through: :positions
  acts_as_votable
  include AlgoliaSearch

  extend FriendlyId
  friendly_id :full_name, use: :slugged

  algoliasearch per_environment: true do
    attribute :last_name, :first_name, :slug, :id
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def participationRate
    positionsCount = self.positions.count
    if positions.count > 0
      absentVotes = self.positions.select { |position| position.votant == false }
      absentCount = absentVotes.count
      ((1 - absentCount.fdiv(positionsCount)) * 100).truncate.fdiv(100)
    else
      0
    end
  end

  def frondingRate
    (100 - self.fronding).fdiv(100)
  end

  def yearlyRevenue
    self.yearly_revenue / 1000
  end

  def filteredParticipationRate(tag)
    positions = self.positions.select { |position| position.law.tag_list.include? tag }
    positionsCount = positions.count
    absentVotes = positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    ((1 - absentCount.fdiv(positionsCount)) * 100).truncate.fdiv(100)
  end

  def make_img_https
    self.img = self.img.gsub('http', 'https')
    self.save
  end

end
