class Vote < ApplicationRecord
  belongs_to :deputy
  belongs_to :law
end
