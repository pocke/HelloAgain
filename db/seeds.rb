# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.create(
  name: 'HackDay', user_ids: [],
)

emails = %w[
  kuwabara@pocke.me
  fujiyama2017s@gmail.com
  tatsuya.spre@gmail.com
  dango.umai@outlook.jp
]

users = emails.map do |e|
  User.create(
    email: e,
    password: 'password',
  )
end


Event.create(
  name: 'Hacker Wars',
  user_ids: users.to(2).map(&:id),
)
