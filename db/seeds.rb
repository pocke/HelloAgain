# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = [
  ['kuwabara@pocke.me', 'Masataka Kuwabara'],
  ['fujiyama2017s@gmail.com', 'fshin'],
  ['tatsuya.spre@gmail.com', 'spre'],
  ['dango.umai@outlook.jp', 'mat'],
]

users = users.map do |email, name|
  u = User.create!(
    email: email,
    name: name,
    password: 'password',
  )

  Card.create!(
    user_id: u.id,
    name: u.name,
    affiliation: "Foo株式会社",
    position: ["エンジニア", "プログラマ"],
    phone: 'xxx-yyy-zzzz'
  )
  u
end


Event.create!(
  name: 'HackDay',
  user_ids: users.from(1).to(2).map(&:id),
)

ev = Event.create!(
  name: 'Hacker Wars',
  user_ids: users.to(2).map(&:id),
)
ev.created_at = 100.days.ago
ev.save!
