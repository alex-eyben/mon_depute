class Deputy < ApplicationRecord
  has_many :positions
  has_many :laws, through: :positions
  acts_as_votable
end
