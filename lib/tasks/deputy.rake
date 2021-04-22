namespace :deputy do
  desc "Update all deputies"
  task update_all: :environment do
    UpdateDeputiesJob.perform_now
    DeleteWrongPositionsJob.perform_now
    GetFrondeurStatusJob.perform_now
    GetPresenceScoreJob.perform_now
    Deputy.reindex!
  end
end
