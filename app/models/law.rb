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

  def generate_tag_list
    tag_list = []
    self.tag_list.each do |tag|
      new_tag = tag.split(" ").reject{ |word| word == "-"}.map(&:capitalize).join
      tag_list << new_tag
    end
    tag_list
  end

  def write_tag_list
    tags_array = self.generate_tag_list
    tags_array.map { |i| i.to_s }.join(" ")
  end
end
