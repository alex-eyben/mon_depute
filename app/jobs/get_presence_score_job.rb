class GetPresenceScoreJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    compute(deputies)
  end

  def compute(deputies)
    deputies.each_with_index do |deputy, i|
      if deputy.positions.any?
        deputy.update(presence: (deputy.positions.where(votant: true).size.fdiv(deputy.positions.size)*100).round(0))
      end
    end
  end
end
