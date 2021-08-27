# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "faker"

puts "Cleaning database..."

Activity.destroy_all
UserActivity.destroy_all
User.destroy_all
Challenge.destroy_all
Artwork.destroy_all
puts "All record Destroyed"
puts "____________________________"
puts "Creating 10 Users + 1 admin (Rocketly/password)"

User.create!(
  email: "admin@rocketly.cool",
  username: "Rocketly",
  password: "password",
  description: Faker::TvShows::HowIMetYourMother.quote,
  country: "France",
  website_url: "rocketly.cool"
)

puts "Create Jul - sneaker challenge"

jul = User.create!(
  email: "jul@jul.fr",
  username: "jul",
  password: "password",
  description: Faker::TvShows::HowIMetYourMother.quote,
  country: "Marseille",
  website_url: "jul.cool"
)

Challenge.create!(
  name: "👽👟🚀",
  description: "Create the next sneakers that Jul will first wear and then sell to his fans",
  reward: "#{rand(100..10_000)}$",
  start_date: Faker::Date.between(from: 3.days.ago, to: 1.day.from_now),
  end_date: Faker::Date.between(from: 1.day.ago, to: 5.days.from_now),
  status: 1,
  user: jul
)

puts "Create Tam - jacket challenge"

tam = User.create!(
  email: "tam@rocketly.cool",
  username: "tam",
  password: "password",
  description: Faker::TvShows::HowIMetYourMother.quote,
  country: "LOLand",
  website_url: "tam.cool"
)

Challenge.create!(
  name: "🧚‍♀️🦺🚀",
  description: "Please dress me with a brand new jacket!",
  reward: "#{rand(100..10_000)}$",
  start_date: Faker::Date.between(from: 3.days.ago, to: 1.day.from_now),
  end_date: Faker::Date.between(from: 1.day.ago, to: 5.days.from_now),
  status: 1,
  user: tam
)

10.times do
  user = User.new(
    email: Faker::Internet.unique.email,
    username: Faker::Name.unique.first_name,
    password: "password",
    description: Faker::TvShows::HowIMetYourMother.quote,
    country: Faker::Address.country,
    website_url: Faker::Internet.domain_name
  )
  user.save!
end

Activity::ACTIVITY.each do |activity|
  Activity.create!(name: activity)
end

50.times do
  user_activity = UserActivity.new(
    user_id: User.all.sample.id,
    activity_id: Activity.all.sample.id
  )
  user_activity.save!
end

CHALLENGES = ["Create my new Chatroom Emojis", "Create my new Youtube cover", "Design my new Sneakers", "I need a new Logo", "Next Album cover design", "New graphic design for next stream"]

puts "10 Users created!"

puts "Creating 30 Challenges"

30.times do
  Challenge.create!(
    name: CHALLENGES.sample,
    description: Faker::Movies::BackToTheFuture.quote,
    reward: "#{rand(100..10_000)}$" + User::REWARDS.sample,
    start_date: Faker::Date.between(from: 3.days.ago, to: 1.day.from_now),
    end_date: Faker::Date.between(from: 1.day.ago, to: 5.days.from_now),
    status: [0, 1, 2, 3].sample,
    user_id: User.all.sample.id
  )
end
puts "30 Challenges created!"

puts "Creating 100 Artworks"

100.times do
  artwork = Artwork.new(
    title: Faker::JapaneseMedia::Naruto.demon,
    description: Faker::JapaneseMedia::OnePiece.quote,
    selected: false,
    user_id: User.all.sample.id,
    challenge_id: Challenge.all.sample.id,
  )
  artwork.save!
end
puts "100 Artworks created!"

puts "Finished!"
