# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# category1 = Category.create(name: "Category 1", path: "ABC")
# category2 = Category.create(name: "Category 2", path: "ABC")
# category3 = Category.create(name: "Category 3", path: "ABC")

5.times do
  food1 = Food.create(
    name: "Dishes 1",
    description: "Description for Dishes 1",
    price: 10,
    category: Category.first
  )
  food1.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image1.jpg')), filename: 'image1.jpg')
end

5.times do
  food2 = Food.create(
    name: "Dishes 2",
    description: "Description for Dishes 2",
    price: 10,
    category: Category.find(2)
  )
  food2.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image1.jpg')), filename: 'image1.jpg')
end

5.times do
  food3 = Food.create(
    name: "Dishes 3",
    description: "Description for Dishes 3",
    price: 10,
    category: Category.find(11)
  )
  food3.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image1.jpg')), filename: 'image1.jpg')
end
