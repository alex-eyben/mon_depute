require "nokogiri"
require "open-uri"

class Law < ApplicationRecord
  has_many :positions
  has_many :deputies, through: :positions

  acts_as_taggable_on :tags

  # def initialize
  #   raise
  # end


end
