
puts "Cleaning database..."
User.destroy_all
Vote.destroy_all
Law.destroy_all
Deputy.destroy_all

puts 'Creating users...'
alex = User.create!(email: "alex@lewagon.org", password: "alex@lewagon.org")
madeline = User.create!(email: "madeline@lewagon.org", password: "madeline@lewagon.org")
ugo = User.create!(email: "ugo@lewagon.org", password: "ugo@lewagon.org")
victor = User.create!(email: "victor@lewagon.org", password: "victor@lewagon.org")
puts 'Finished creating users...'

puts "Creating deputies..."

amadou = { first_name: "Aude", last_name: "Amadou", email: "aude.amadou@assemblee-nationale.fr", job: "Ex-sportive de haut niveau", birth_place: "Coutances", birth_date: Time.now.to_datetime, party: "LREM", twitter: "https://twitter.com/AudeAmadou", facebook: "AmadouAude", website: "www.aude-amadou.info", revenue: 45000, circonscription: 4 }
ferrara = { first_name: "Jean-Jacques", last_name: "Ferrara", email: "jean-jacques.ferrara@assemblee-nationale.fr", job: "Médecin", birth_place: "Marseille", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@JJFerara", facebook: "JJFerara", website: "www.ferrara.info", revenue: 78000, circonscription: 1 }
thillaye = { first_name: "Sabine", last_name: "Thillaye", email: "sabine.thillaye@assemblee-nationale.fr", job: "Chef d'entreprise", birth_place: "Remscheid", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@SabineThillaye", facebook: "SabineThillaye", website: "www.sabine-thillaye.info", revenue: 52000, circonscription: 5 }

deputies = []
[ amadou, ferrara, thillaye ].each do |attributes|
  deputy = Deputy.create!(attributes)
  puts "Created #{deputy.last_name}"
  deputies << deputy
end

# we can use following method to create attributes based on actual deputies. For the moment we're limited to 25 as method breaks on the 26th for insane reasons. WIP
# ImportDeputiesJob.perform_now(25)
# The method returns an array we can iterate on instead of on deputies
# to try, un comment following lines and comment lines 17 to 26

# deputies = []
# ImportDeputiesJob.perform_now(25).each do |attributes|
#   deputy = Deputy.create!(attributes)
#   puts "Created #{deputy.last_name}"
#   deputies << deputy
# end

puts "Creating laws..."
lois_du_11_mai = { title: "Lois du 11 mai", 
            content: "Présenté au Conseil des ministres du 2 mai 2020 par Édouard Philippe, 
            Premier ministre, le projet de loi avait été adopté en première lecture
             avec modifications par le Sénat le 5 mai et par l'Assemblée nationale le 8 mai 2020. 
             Après accord en commission mixte paritaire, le texte avait été définitivement adopté 
             par l'Assemblée nationale et par le Sénat le 9 mai.
            Le 2 mai, le gouvernement a engagé la procédure accélérée.", 
            ressource_link: "https://vie-publique.fr/loi/274230-loi-du-11-mai-2020-prolongation-etat-durgence-sanitaire", 
            current_status: "adoptée", 
            last_status_update: Date.today, 
            start_date:  Date.today
            }
loi_du_13_mai =  { title: "Lois du 13 mai", 
                content: "La Commission invite les pays de l'UE et ceux associés à 
                l'espace Schengen (Islande, Liechtenstein, Norvège, Suisse) à s’engager à lever 
                progressivement les contrôles aux frontières intérieures. 
                Elle propose également une approche par étapes pour rétablir des déplacements sans restrictions.", 
                ressource_link: "https://www.vie-publique.fr/en-bref/274361-retour-progressif-la-libre-circulation-des-personnes", 
                current_status: "en cours", 
                last_status_update:  Date.today, 
                start_date:  Date.today
              }

laws = []
[lois_du_11_mai, loi_du_13_mai ].each do |attributes|
  law = Law.create!(attributes)
  puts "Created #{law.title}"
  laws << law
end

puts "Creating votes..."

contre = Vote.create!(deputy_position: "Contre", deputy: deputies.sample, law: laws.sample )
pour = Vote.create!(deputy_position: "Pour", deputy: deputies.sample, law: laws.sample )
abstenu = Vote.create!(deputy_position: "Abstenu", deputy: deputies.sample, law: laws.sample )

puts "Finished!"
