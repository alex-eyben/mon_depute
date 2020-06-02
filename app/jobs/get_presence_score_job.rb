class GetPresenceScoreJob < ApplicationJob
  queue_as :default

  def perform(deputies)
    @counter = 1
    @total = deputies.size
    compute(deputies)
  end

  def compute(deputies)
    print "\r#{((@counter.fdiv(@total))*100).round(2)}%" + " ...Computing presence score..." + ['/', '-', '\\'].sample
    @counter += 1
    deputies.each{|deputy| deputy.update(presence: (deputy.positions.where(votant: true).size.fdiv(deputy.positions.size)*100).round(0))}
  end
end
