# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

4.times do |index|
  Court.create(name: "#{(index + 1).humanize} court", court_type: index, active: true)
end

Customer.create!([{provider: "email", uid: "test@test.com", password: "password"}])