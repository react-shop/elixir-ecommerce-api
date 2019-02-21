# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#10.times  do
#	User.create({
#		username: Faker::Name.first_name,
 #   password: Faker::Name.last_name,
 #   password_confirmation: Faker::Name.last_name,
  #  access: Faker::Number.within(0..1),
   # name: Faker::Name.name
#	})
#end

User.create!(
  username: 'viniarruda', 
  password: 'a123', 
  password_confirmation: 'a123', 
  access: 1, 
  name: 'Vinicius Arruda')

10.times  do
	Product.create({
		sku: Faker::Number.number(6),
    item: Faker::Book.title,
    color: Faker::Color.hex_color,
    size: 'M',
    cod: Faker::Number.between(1, 50),
    stock: Faker::Number.between(1, 20)
	})
end
