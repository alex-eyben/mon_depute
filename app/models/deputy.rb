class Deputy < ApplicationRecord
  has_many :positions
  has_many :laws, through: :positions
end
