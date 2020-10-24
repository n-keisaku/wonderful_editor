# rubocop:disable all
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6)}

  end
end
# rubocop:enable all
