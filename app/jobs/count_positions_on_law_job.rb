class CountPositionsOnLawJob < ApplicationJob
  queue_as :default

  def perform(law)
    law.pour = law.positions.where(deputy_position: "pour").size
    law.contre = law.positions.where(deputy_position: "contre").size
    law.abstenu = law.positions.where(deputy_position: "abstention").size
    law.save
  end
end
