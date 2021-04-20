class Law < ApplicationRecord
  has_many :positions, dependent: :destroy
  has_many :deputies, through: :positions

  after_create :populate_law

  acts_as_taggable_on :tags

  def self.last_three
    Law.order(last_status_update: :desc).first(3)
  end

  def populate_law
    ImportPositionsJob.perform_later([self.scrutin_id])
    AddTagsToLawJob.perform_later(self)
    CountPositionsOnLawJob.perform_later(self)
    GetFrondeurStatusJob.perform_later
    GetPresenceScoreJob.perform_later
  end
end
