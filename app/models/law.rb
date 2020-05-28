class Law < ApplicationRecord
  has_many :positions
  has_many :deputies, through: :positions

  acts_as_taggable_on :tags
end
