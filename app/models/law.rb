class Law < ApplicationRecord
  has_many :positions, dependent: :destroy
  has_many :deputies, through: :positions

  acts_as_taggable_on :tags
end
