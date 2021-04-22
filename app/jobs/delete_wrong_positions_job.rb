class DeleteWrongPositionsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Position.all.each do |position|
      deputy = Deputy.find(position.deputy_id)
      law = Law.find(position.law_id)
      if deputy.entry_date.nil? || deputy.entry_date <= law.last_status_update || position.deputy_position == "nonVotant"
        puts "keeping"
      else
        position.delete
      end
    end
  end
end
