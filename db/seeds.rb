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
lois  = { title: "Dishoom", 
            content: "7 Boundary St, London E2 7JE", 
            ressource_link: 5, 
            current_status: 5, 
            last_status_update: 5, 
            start_date: 5,
            created_at: 5,
            updated_at: 5 }
pizza_east =  { title: "Dishoom", 
                content: "7 Boundary St, London E2 7JE", 
                ressource_link: 5, 
                current_status: 5, 
                last_status_update: 5, 
                start_date: 5,
                created_at: 5,
                updated_at: 5  
              }

[ dishoom, pizza_east ].each do |attributes|
  law = Law.create!(attributes)
  puts "Created #{law.title}"
end
puts "Finished!