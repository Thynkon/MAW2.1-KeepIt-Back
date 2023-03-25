# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

mario = User.create!(username: "mario", email: "mario@mail.com", password: "password", status: "verified")
armand = User.create!(username: "armand", email: "armand@mail.com", password: "password", status: "verified")
anthony = User.create!(username: "anthony", email: "anthony@mail.com", password: "password", status: "verified")
theo = User.create!(username: "theo", email: "theo@mail.com", password: "password", status: "verified")
helene = User.create!(username: "helene", email: "helene@mail.com", password: "password", status: "verified")
demo = User.create!(username: "demo", email: "demo@mail.com", password: "password", status: "verified")

users = User.all

achievements = []

100.times do |i|
    achievements << Achievement.create!(title: "#{Faker::Book.title}#{i}" , description: Faker::Lorem.paragraph, percentage: rand(1..100))
end

# Add one achievement to each user (except demo)
users.each do |user|
    if user.username != "demo"
        user.achievements << achievements.sample
        user.save!
    end
end

# Add all achivements to demo user
Achievement.all.each do |achievement|
    demo.achievements << achievement
    demo.save!
end


