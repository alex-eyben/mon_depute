class Law < ApplicationRecord
  has_many :positions, dependent: :destroy
  has_many :deputies, through: :positions

  acts_as_taggable_on :tags

  def self.last_three
    Law.order(last_status_update: :desc).first(3)
  end
end
