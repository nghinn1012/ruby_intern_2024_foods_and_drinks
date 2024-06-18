require "faker"

FactoryBot.define do
  factory :category do
    name { Faker::Food.ethnic_category }
    path { Faker::Internet.slug }
  end

  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.between(from: 100, to: 10000) }
    available_item { Faker::Number.between(from: 1, to: 100) }

    association :category

    after(:build) do |food|
      food.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end
