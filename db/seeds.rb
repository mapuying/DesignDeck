# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

create_account = User.create([email: 'designer@designerdeck.com', password: '111111', password_confirmation: '111111', is_designer: 'true'])
create_account = User.create([email: 'user1@designerdeck.com', password: '111111', password_confirmation: '111111', is_designer: 'false'])
create_account = User.create([email: 'user2@designerdeck.com', password: '111111', password_confirmation: '111111', is_designer: 'false'])


