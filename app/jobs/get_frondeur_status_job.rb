class GetFrondeurStatusJob < ApplicationJob
  queue_as :default

  def perform
    Deputy.all.each do |deputy|
      update_fronding_score(deputy)
    end
  end

  def update_fronding_score(deputy)
    puts "we begin for deputy #{deputy.id}"
    same_group_different_votes = 0
    if deputy.positions.any?
      deputy.positions.each do |position|
        if position.votant?
          same_group_different_votes += 1 if position.deputy_position != position.deputy_group_position
        end
      end
      deputy.update(fronding: (same_group_different_votes.fdiv(deputy.positions.size)*100).round(0))
      deputy.save
      puts "#{deputy.id} has been updated"
    end
  end
end
