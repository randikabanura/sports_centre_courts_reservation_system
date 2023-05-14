# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

if Court.count.zero?
  4.times do |index|
    Court.create(name: "#{(index + 1).humanize} court", court_type: index, active: true)
  end
end

Customer.create!([{ provider: "email", uid: "test@test.com", email: "test@test.com", password: "password" }])