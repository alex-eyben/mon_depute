# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Cleaning database..."
Law.destroy_all

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

[lois_du_11_mai, loi_du_13_mai ].each do |attributes|
  law = Law.create!(attributes)
  puts "Created #{law.title}"
end
puts "Finished!"