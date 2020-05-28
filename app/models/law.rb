class Law < ApplicationRecord
  has_many :positions

  acts_as_taggable_on :tags
end
