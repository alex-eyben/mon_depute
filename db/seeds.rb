require "csv"

def cleaning
  puts "Cleaning database..."
  User.destroy_all
  Vote.destroy_all
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
  puts "Creating laws..."
  avia = { title: "Loi Avia visant à lutter contre les contenus haineux sur internet",
              content: "La proposition de loi oblige les opérateurs de plateforme en ligne et
              les moteurs de recherche à retirer dans un délai de 24 heures, après notification
              par une ou plusieurs personnes, des contenus manifestement illicites tels que les
              incitations à la haine, les injures à caractère raciste ou anti-religieuses.
              Pour les contenus terroristes ou pédopornographiques, le délai de retrait est
              réduit à une heure.",
              ressource_link: "https://www.vie-publique.fr/loi/268070-loi-avia-lutte-contre-les-contenus-haineux-sur-internet",
              current_status: "Adoptée",
              last_status_update: Date.today,
              start_date:  Date.today,
              scrutin_id: 2039

              }
  bioethique =  { title: "Projet de loi relatif à la bioéthique",
                  content: "Le projet de loi élargit l'accès à la procréation médicalement assistée
                  (PMA) aux couples de femme et aux femmes célibataires. Actuellement,
                  la PMA est uniquement accessible aux couples hétérosexuels sur indication médicale. ",
                  ressource_link: "https://www.vie-publique.fr/loi/268659-projet-de-loi-bioethique-pma",
                  current_status: "Adoptée",
                  last_status_update:  Date.today,
                  start_date:  Date.today,
                  scrutin_id: 2146
                }
  violences =  { title: "Loi du 28 décembre 2019 visant à agir contre les violences au sein de la famille",
                  content: "Le texte vise à faire reculer les violences faites aux femmes et notamment les féminicides.
                  La loi fixe à six jours maximum le délai de délivrance par le juge aux affaires familiales d’une
                  ordonnance de protection. Créée par la loi du 9 juillet 2010 relative aux
                  violences faites spécifiquement aux femmes, aux violences au sein des couples et aux
                  incidences de ces dernières sur les enfants l’ordonnance de protection permet au juge
                  d’attester de la réalité des violences subies et de mettre en place, sans attendre la
                  décision de la victime sur le dépôt d’une plainte, les mesures d’urgence : éviction du
                  conjoint violent, relogement 'hors de portée du conjoint en cas de départ du domicile conjugal,
                  interdiction pour le conjoint violent de porter une arme.'",
                  ressource_link: "https://www.vie-publique.fr/loi/271281-proposition-de-loi-action-contre-les-violences-au-sein-de-la-famille",
                  current_status: "Adoptée",
                  last_status_update:  Date.today,
                  start_date:  Date.today,
                  scrutin_id: 2147
                }
  urgence =  { title: "Etat d'urgence : loi renforçant la sécurité intérieure et la lutte contre le terrorisme",
                  content: "La loi vise à doter l'État de nouveaux instruments de lutte contre le terrorisme
                  afin de pouvoir mettre fin au régime dérogatoire de l'état d'urgence.
                  Pour cela, la loi intègre dans le droit commun des dispositions jusque-là réservées à l'état d'urgence.",
                  ressource_link: "https://www.vie-publique.fr/loi/20775-loi-securite-interieure-et-la-lutte-contre-le-terrorisme",
                  current_status: "Adoptée",
                  last_status_update:  Date.today,
                  start_date:  Date.today,
                  scrutin_id: 138
                }
  climat =  { title: "Projet de loi relatif à l'énergie et au climat",
                  content: "La loi énergie et climat du 8 novembre 2019 vise à répondre à l’urgence
                  écologique et climatique. Elle inscrit cette urgence dans le code de l’énergie
                  ainsi que l’objectif d'une neutralité carbone en 2050, en divisant les émissions
                  de gaz à effet de serre par six au moins d'ici cette date.",
                  ressource_link: "https://www.vie-publique.fr/loi/23814-loi-energie-et-climat-du-8-novembre-2019",
                  current_status: "Adoptée",
                  last_status_update:  Date.today,
                  start_date:  Date.today,
                  scrutin_id: 2065
                }
  peche =  { title: "Interdiction de la pêche électrique",
                  content: "Interdite dans de nombreux pays, la pêche électrique consiste à
                  capturer des poissons à l'aide d'un courant électrique. Des décharges sont envoyées
                  dans le sédiment afin de capturer les poissons plats (soles, limandes, carrelets, etc.).
                  Cette méthode est critiquée pour son impact sur les poissons : ces derniers montrent souvent
                  des brûlures, des ecchymoses et des déformations du squelette consécutives à
                  l'électrocution. La pêche électrique se distingue également par son caractère non
                  sélectif, atteignant sans distinction tous les organismes à portée de l'impulsion.
                  En mer du Nord, où elle est pratiquée depuis une dizaine d'années, les ressources
                  halieutiques de la zone se raréfient, en particulier les stocks de soles et de plies.",
                  ressource_link: "https://www.vie-publique.fr/en-bref/19954-union-europeenne-protestations-contre-la-peche-electrique",
                  current_status: "Adoptée",
                  last_status_update:  Date.today,
                  start_date:  Date.today,
                  scrutin_id: 389
                }

  @laws = []
  [ avia, bioethique, violences, urgence, climat, peche ].each do |attributes|
    law = Law.create!(attributes)
    puts "Created #{law.title}"
    @laws << law
  end
  puts "laws done"
end

def creating_votes_light
  puts "Creating votes..."

  contre = Vote.create!(deputy_position: "Contre", deputy: @deputies.sample, law: @laws.sample )
  pour = Vote.create!(deputy_position: "Pour", deputy: @deputies.sample, law: @laws.sample )
  abstenu = Vote.create!(deputy_position: "Abstenu", deputy: @deputies.sample, law: @laws.sample )
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

def creating_locations_light
  puts "Creating locations light..."

  abergement = Location.create!(department: 1, commune: "L'Abergement-de-Varey", circonscription: 420)
  portes = Location.create!(department: 30, commune: "Portes", circonscription: 420)
  nouzilly = Location.create!(department: 37, commune: "Nouzilly", circonscription: 182)
  lille = Location.create!(department: 59, commune: "Lille", circonscription: 92)
  puts "locations done"
end

def creating_locations_full
  # Location from CSV, uncomment to create 37k locations
  puts "Creating locations full..."
  print "loading"
  file_path = Rails.root.join("db/csv", "locations.csv")
  options = { col_sep: ";", headers: :first_row }
  CSV.foreach(file_path, options).with_index do |row, i|
    department_code = row[1].to_i
    commune = row[6]
    circonscription = row[8].to_i
    Location.create!(department: department_code, commune: commune, circonscription: circonscription)
    print "\r#{100*i/37500}%     " # display a percentage on the CLI
  end
  puts " ===> \\o/"
  puts "locations done"
end

def creating_locations(full_or_light)
  if full_or_light == "light"
    creating_locations_light
  elsif full_or_light == "full"
    creating_locations_full
  else
    puts "==> Wrong argument!! Choose 'full' or 'light' ! No location created"
  end
end

def seed(full_or_light)
  puts "Let's go!"
  puts full_or_light + " version!"
  cleaning
  creating_users
  creating_deputies(full_or_light)
  creating_laws
  creating_votes(full_or_light)
  creating_locations("full")
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
