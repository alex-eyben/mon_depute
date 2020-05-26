
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#puts "Cleaning database..."
#Law.destroy_all

#puts "Creating laws..."
#lois_du_11_mai = { title: "Lois du 11 mai", 
#            content: "Présenté au Conseil des ministres du 2 mai 2020 par Édouard Philippe, 
#            Premier ministre, le projet de loi avait été adopté en première lecture
#             avec modifications par le Sénat le 5 mai et par l'Assemblée nationale le 8 mai 2020. 
#             Après accord en commission mixte paritaire, le texte avait été définitivement adopté 
#             par l'Assemblée nationale et par le Sénat le 9 mai.
#            Le 2 mai, le gouvernement a engagé la procédure accélérée.", 
#            ressource_link: "https://vie-publique.fr/loi/274230-loi-du-11-mai-2020-prolongation-etat-durgence-sanitaire", 
#            current_status: "adoptée", 
#            last_status_update: Date.today, 
#            start_date:  Date.today
#            }
#loi_du_13_mai =  { title: "Lois du 13 mai", 
#                content: "La Commission invite les pays de l'UE et ceux associés à 
#                l'espace Schengen (Islande, Liechtenstein, Norvège, Suisse) à s’engager à lever 
#                progressivement les contrôles aux frontières intérieures. 
#                Elle propose également une approche par étapes pour rétablir des déplacements sans restrictions.", 
#                ressource_link: "https://www.vie-publique.fr/en-bref/274361-retour-progressif-la-libre-circulation-des-personnes", 
#                current_status: "en cours", 
#                last_status_update:  Date.today, 
#                start_date:  Date.today
#              }

#[lois_du_11_mai, loi_du_13_mai ].each do |attributes|
#  law = Law.create!(attributes)
#  puts "Created #{law.title}"
#end
#puts "Finished!"


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

puts "Creating laws..."
bioethique = { title: "Projet de loi relatif à la bioéthique", content: "La loi du 7 juillet 2011 relative à la bioéthique prévoit une révision de la loi par le Parlement dans un délai maximal de sept ans, précédé de l’organisation d’états généraux confiée au Comité consultatif national d’éthique pour les sciences de la vie et de la santé.", ressource_link: "https://vie-publique.fr/loi/268659-projet-de-loi-bioethique-pma", current_status: "Examen et adoption", last_status_update: Time.now.to_datetime, start_date: Time.now.to_datetime }
covid = { title: "Projet de loi relatif au Covid-19", content: "Le projet de loi contient 33 habilitations pour légiférer par ordonnances pour faire face aux conséquences de la crise sanitaire et du confinement.", ressource_link: "https://vie-publique.fr/loi/274274-loi-diverses-dispositions-urgentes-pour-consequences-du-covid-19", current_status: "Promulgation", last_status_update: Time.now.to_datetime, start_date: Time.now.to_datetime }

laws = []
[ bioethique, covid ].each do |attributes|
  law = Law.create!(attributes)
  puts "Created #{law.title}"
  laws << law
end

puts "Creating votes..."

contre = Vote.create!(deputy_position: "Contre", deputy: deputies.sample, law: laws.sample )
pour = Vote.create!(deputy_position: "Pour", deputy: deputies.sample, law: laws.sample )
abstenu = Vote.create!(deputy_position: "Abstenu", deputy: deputies.sample, law: laws.sample )

puts "Finished!"



