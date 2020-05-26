
puts "Cleaning database..."
Deputy.destroy_all

puts "Creating deputies..."
amadou = { first_name: "Aude", last_name: "Amadou", email: "aude.amadou@assemblee-nationale.fr", job: "Ex-sportive de haut niveau", birth_place: "Coutances", birth_date: Time.now.to_datetime, party: "LREM", twitter: "https://twitter.com/AudeAmadou", facebook: "AmadouAude", website: "www.aude-amadou.info", revenue: 45000, circonscription: 4 }
ferrara = { first_name: "Jean-Jacques", last_name: "Ferrara", email: "jean-jacques.ferrara@assemblee-nationale.fr", job: "Médecin", birth_place: "Marseille", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@JJFerara", facebook: "JJFerara", website: "www.ferrara.info", revenue: 78000, circonscription: 1 }
thillaye = { first_name: "Sabine", last_name: "Thillaye", email: "sabine.thillaye@assemblee-nationale.fr", job: "Chef d'entreprise", birth_place: "Remscheid", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@SabineThillaye", facebook: "SabineThillaye", website: "www.sabine-thillaye.info", revenue: 52000, circonscription: 5 }

[ amadou, ferrara, thillaye ].each do |attributes|
  deputy = Deputy.create!(attributes)
  puts "Created #{deputy.last_name}"
end

puts "Finished!"
