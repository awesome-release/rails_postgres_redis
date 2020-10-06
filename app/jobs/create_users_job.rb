class CreateUsersJob
  include Sidekiq::Worker

  def perform
    10.times do
      User.create(name: Faker::Name.name, email: Faker::Internet.email)
    end
  end
end
