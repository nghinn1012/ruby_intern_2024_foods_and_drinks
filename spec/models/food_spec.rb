require "rails_helper"

RSpec.describe Food, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      food = FactoryBot.build(:food)
      expect(food).to be_valid
    end

    it "is not valid without a name" do
      food = FactoryBot.build(:food, name: nil)
      expect(food).not_to be_valid
    end

    it "is not valid without a price" do
      food = FactoryBot.build(:food, price: nil)
      expect(food).not_to be_valid
    end

    it "is not valid without a category" do
      food = FactoryBot.build(:food, category: nil)
      expect(food).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }

    it "has one attached image" do
      expect(Food.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    it "purges the image later when the food is destroyed" do
      food = FactoryBot.create(:food)
      food.image.attach(io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")), filename: "test_image.png", content_type: "image/png")

      expect { food.destroy }.to change { ActiveStorage::Attachment.count }.by(-1)
    end
  end

  describe "scopes" do
    let!(:category1) { create(:category, name: "Category 1") }
    let!(:category2) { create(:category, name: "Category 2") }
    let!(:food1) { create(:food, name: "Food 1", price: 500, available_item: 5, category: category1) }
    let!(:food2) { create(:food, name: "Food 2", price: 1500, available_item: 10, category: category2) }
    let!(:food3) { create(:food, name: "Food 2", price: 2000, available_item: 0, category: category1) }

    describe ".search" do
      it "returns foods matching the search term" do
        expect(Food.search("Food 1")).to include(food1)
        expect(Food.search("Food 1")).not_to include(food2)
      end
    end

    describe ".all_of_category" do
      it "returns foods belonging to the specified category" do
        expect(Food.all_of_category(category1.id)).to include(food1, food3)
        expect(Food.all_of_category(category1.id)).not_to include(food2)
      end
    end

    describe ".filter_by_price" do
      it "returns foods within the specified price range" do
        expect(Food.filter_by_price(1000, 2000)).to include(food2, food3)
        expect(Food.filter_by_price(1000, 2000)).not_to include(food1)
      end
    end

    describe ".order_by_name" do
      it "returns foods ordered by name" do
        expect(Food.order_by_name(:asc)).to eq([food1, food2, food3])
      end
    end

    describe ".order_by_created_at" do
      it "returns foods ordered by creation date" do
        expect(Food.order_by_created_at).to eq([food3, food2, food1])
      end
    end

    describe ".order_by_quantity" do
      it "returns foods ordered by available items" do
        expect(Food.order_by_quantity).to eq([food2, food1, food3])
      end
    end

    describe ".filter_by_category_ids" do
      it "returns foods belonging to the specified categories" do
        expect(Food.filter_by_category_ids([category1.id, category2.id])).to include(food1, food2, food3)
        expect(Food.filter_by_category_ids([category1.id])).to include(food1, food3)
      end
    end

    describe ".find_ids" do
      it "returns foods with the specified ids" do
        expect(Food.find_ids([food1.id, food2.id])).to include(food1, food2)
        expect(Food.find_ids([food1.id, food2.id])).not_to include(food3)
      end
    end
  end
end
