class Position < ApplicationRecord
  belongs_to :deputy
  belongs_to :law
  acts_as_votable
end
