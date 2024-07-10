# seeds.rb

# Domain creation with password expiration frequency
domain1 = Domain.create(name: 'example.com', password_expiration_frequency: 30)
domain2 = Domain.create(name: 'any-example.com', password_expiration_frequency: 60)
domain3 = Domain.create(name: 'other-example.com', password_expiration_frequency: 90)
domain4 = Domain.create(name: 'another-example.com', password_expiration_frequency: 180)

# Examples of domain-associated email boxes
Mailbox.create(domain: domain1, username: 'user1', password: 'password', scheduled_password_expiration: 1.day.ago)
Mailbox.create(domain: domain2, username: 'user2', password: 'password', scheduled_password_expiration: 1.day.ago)
Mailbox.create(domain: domain3, username: 'user3', password: 'password', scheduled_password_expiration: 1.day.ago)
Mailbox.create(domain: domain4, username: 'user4', password: 'password', scheduled_password_expiration: 1.day.ago)

puts 'Seed data created successfully'

Mailbox.pluck(:scheduled_password_expiration).map { |date| date.strftime("%d/%m/%Y") }