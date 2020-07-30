class GetPresenceScoreJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    @total = deputies.size
    compute(deputies)
  end

  def compute(deputies)
    deputies.each_with_index do |deputy, i|
      if deputy.positions.any?
        deputy.update(presence: (deputy.positions.where(votant: true).size.fdiv(deputy.positions.size)*100).round(0))
        print "\r#{(((i+1).fdiv(@total))*100).round(2)}%" + " ...Computing presence score..." + ['/', '-', '\\'].sample
      end
    end
  end
end
