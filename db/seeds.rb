
puts "Cleaning database..."
User.destroy_all
Vote.destroy_all
Law.destroy_all
Deputy.destroy_all
Location.destroy_all

puts 'Creating users...'
alex = User.create!(email: "alex@lewagon.org", password: "alex@lewagon.org")
madeline = User.create!(email: "madeline@lewagon.org", password: "madeline@lewagon.org")
ugo = User.create!(email: "ugo@lewagon.org", password: "ugo@lewagon.org")
victor = User.create!(email: "victor@lewagon.org", password: "victor@lewagon.org")
puts 'Finished creating users...'

puts "Creating deputies..."

amadou = { first_name: "Aude", last_name: "Amadou", email: "aude.amadou@assemblee-nationale.fr", job: "Ex-sportive de haut niveau", birth_place: "Coutances", birth_date: Time.now.to_datetime, party: "LREM", twitter: "https://twitter.com/AudeAmadou", facebook: "AmadouAude", website: "www.aude-amadou.info", revenue: 45000, circonscription: 420, department: 67 }
ferrara = { first_name: "Jean-Jacques", last_name: "Ferrara", email: "jean-jacques.ferrara@assemblee-nationale.fr", job: "Médecin", birth_place: "Marseille", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@JJFerara", facebook: "JJFerara", website: "www.ferrara.info", revenue: 78000, circonscription: 182, department: 37 }
thillaye = { first_name: "Sabine", last_name: "Thillaye", email: "sabine.thillaye@assemblee-nationale.fr", job: "Chef d'entreprise", birth_place: "Remscheid", birth_date: Time.now.to_datetime, party: "LREM", twitter: "@SabineThillaye", facebook: "SabineThillaye", website: "www.sabine-thillaye.info", revenue: 52000, circonscription: 92, department: 92 }

deputies = []
[ amadou, ferrara, thillaye ].each do |attributes|
  deputy = Deputy.create!(attributes)
  puts "Created #{deputy.last_name}"
  deputies << deputy
end

# we can use following method to create attributes based on actual deputies.
# ImportDeputiesJob.perform_now
# We can pass a number in arg to limit number of deputies, ie :
# ImportDeputiesJob.perform_now(10)
# The method returns an array we can iterate on instead of on deputies
# to try, un-comment following lines and comment lines 17 to 26

# deputies = []
# ImportDeputiesJob.perform_now.each do |attributes|
#   deputy = Deputy.create!(attributes)
#   puts "Created #{deputy.last_name}"
#   deputies << deputy
# end

puts "Creating laws..."
avia = { title: "Loi Avia visant à lutter contre les contenus haineux sur internet",
            content: "La proposition de loi oblige les opérateurs de plateforme en ligne et les moteurs de recherche à retirer 
            dans un délai de 24 heures, après notification par une ou plusieurs personnes, des contenus 
            manifestement illicites tels que les incitations à la haine, les injures à caractère raciste 
            ou anti-religieuses. Pour les contenus terroristes ou pédopornographiques, le délai de retrait 
            est réduit à une heure.",
            ressource_link: "https://www.vie-publique.fr/loi/268070-loi-avia-lutte-contre-les-contenus-haineux-sur-internet",
            current_status: "Adoptée",
            last_status_update: Date.today,
            start_date:  Date.today
            scrutin_id: 2039
            }
loi_du_13_mai =  { title: "Loi du 13 mai",
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

puts "Creating locations..."

abergement = Location.create!(department: 1, commune: "L'Abergement-de-Varey", circonscription: 420)
portes = Location.create!(department: 30, commune: "Portes", circonscription: 420)
nouzilly = Location.create!(department: 37, commune: "Nouzilly", circonscription: 182)
lille = Location.create!(department: 59, commune: "Lille", circonscription: 92)

puts "Finished!"
