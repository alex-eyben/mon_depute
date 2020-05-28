class Law < ApplicationRecord
  has_many :votes

  acts_as_taggable_on :tags
end
