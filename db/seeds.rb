# require "csv"

def cleaning
  puts "Cleaning database..."
  User.destroy_all
  Position.destroy_all
  Law.destroy_all
  Deputy.destroy_all
  Location.destroy_all
end

def creating_users
  puts 'Creating users...'
  alex = User.create!(email: "alex@lewagon.org", password: "alex@lewagon.org")
  madeline = User.create!(email: "madeline@lewagon.org", password: "madeline@lewagon.org")
  ugo = User.create!(email: "ugo@lewagon.org", password: "ugo@lewagon.org")
  victor = User.create!(email: "victor@lewagon.org", password: "victor@lewagon.org")
  puts 'Finished creating users...'
end

def creating_deputies_light
  puts "Creating deputies..."

  amadou = { first_name: "Aude", last_name: "Amadou", email: "aude.amadou@assemblee-nationale.fr", job: "Ex-sportive de haut niveau", birth_place: "Coutances", birth_date: Time.now.to_datetime, party: "LREM", twitter: "https://twitter.com/AudeAmadou", facebook: "AmadouAude", website: "www.aude-amadou.info", revenue: 45000, circonscription: 5, department: 1 }
  ferrara = { first_name: "Jean-Jacques", last_name: "Ferrara", email: "jean-jacques.ferrara@assemblee-nationale.fr", job: "Médecin", birth_place: "Marseille", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@JJFerara", facebook: "JJFerara", website: "www.ferrara.info", revenue: 78000, circonscription: 420, department: 92 }
  thillaye = { first_name: "Sabine", last_name: "Thillaye", email: "sabine.thillaye@assemblee-nationale.fr", job: "Chef d'entreprise", birth_place: "Remscheid", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@SabineThillaye", facebook: "SabineThillaye", website: "www.sabine-thillaye.info", revenue: 52000, circonscription: 92, department: 92 }

  @deputies = []
  [ amadou, ferrara, thillaye ].each do |attributes|
    deputy = Deputy.create!(attributes)
    puts "Created #{deputy.last_name}"
    @deputies << deputy
  end
  puts "deputies done"
end

def creating_deputies_full
# we can use following method to create attributes based on actual deputies.
# ImportDeputiesJob.perform_now
# We can pass a number in arg to limit number of deputies, ie :
# ImportDeputiesJob.perform_now(10)
# The method returns an array we can iterate on instead of on deputies

# to try, un-comment following lines and comment lines 19 to 28
  puts "Creating deputies..."

  @deputies = []
  ImportDeputiesJob.perform_now.each do |attributes|
    deputy = Deputy.create!(attributes)
    puts "Created #{deputy.last_name}"
    @deputies << deputy
  end
  puts "deputies done"
end

def creating_deputies(full_or_light)
  if full_or_light == "light"
    creating_deputies_light
  elsif full_or_light == "full"
    creating_deputies_full
  else
    puts "==> Wrong argument!! Choose 'full' or 'light' ! No deputy created"
  end
end

def creating_laws
  CreateLawsJob.perform_now
  puts "laws done"
end

def creating_votes_light
  puts "Creating votes..."

  contre = Position.create!(deputy_position: "Contre", deputy: @deputies.first, law: @laws.sample )
  pour = Position.create!(deputy_position: "Pour", deputy: @deputies.first, law: @laws.sample )
  abstenu = Position.create!(deputy_position: "Abstenu", deputy: @deputies.first, law: @laws.sample )
end

def creating_votes_full
  puts "Creating votes..."
  ImportVotesJob.perform_now(10000,Law.all.map(&:scrutin_id))
  puts "votes done"
end

def creating_votes(full_or_light)
  if full_or_light == "light"
    creating_votes_light
  elsif full_or_light == "full"
    creating_votes_full
  else
    puts "==> Wrong argument!! Choose 'full' or 'light' ! No location created"
  end
end

# def creating_locations_light
#   puts "Creating locations light..."

#   abergement = Location.create!(department: 1, commune: "L'Abergement-de-Varey", circonscription: 420)
#   portes = Location.create!(department: 30, commune: "Portes", circonscription: 420)
#   nouzilly = Location.create!(department: 37, commune: "Nouzilly", circonscription: 182)
#   lille = Location.create!(department: 59, commune: "Lille", circonscription: 92)
#   puts "locations done"
# end

# def creating_locations_full
#   # Location from CSV, uncomment to create 37k locations
#   puts "Creating locations full..."
#   print "loading"
#   file_path = Rails.root.join("db/csv", "locations.csv")
#   options = { col_sep: ";", headers: :first_row }
#   CSV.foreach(file_path, options).with_index do |row, i|
#     department_code = row[1].to_i
#     commune = row[6]
#     circonscription = row[8].to_i
#     Location.create!(department: department_code, commune: commune, circonscription: circonscription)
#     print "\r#{100*i/37500}%     " # display a percentage on the CLI
#   end
#   puts " ===> \\o/"
#   puts "locations done"
# end

# def creating_locations(full_or_light)
#   if full_or_light == "light"
#     creating_locations_light
#   elsif full_or_light == "full"
#     creating_locations_full
#   else
#     puts "==> Wrong argument!! Choose 'full' or 'light' ! No location created"
#   end
# end

def seed(full_or_light)
  puts "Let's go!"
  puts full_or_light + " version!"
  cleaning
  creating_users
  creating_deputies(full_or_light)
  creating_laws
  creating_votes(full_or_light)
  # creating_locations("full")
  puts "Finished!"
end

puts "Full seed or light seed ? (type 'full' or 'light')"
print "> "
full_or_light = STDIN.gets.chomp
if full_or_light == 'light' || full_or_light == 'full'
  seed(full_or_light)
else
  puts "operation cancelled -- type 'full' or 'light' next time... So long! "
end
