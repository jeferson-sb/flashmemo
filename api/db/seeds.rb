# frozen_string_literal: true

require_relative 'seeder'

seeder = Seeder.new(
  User,
  Category,
  Garden,
  Tree,
  Question,
  Option,
  Exam
)

seeder.seed!

puts "\nDone! 🎉"
