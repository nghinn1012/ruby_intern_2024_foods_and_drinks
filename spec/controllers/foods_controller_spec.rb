require "rails_helper"

RSpec.describe FoodsController, type: :controller do
  describe "GET #index" do
    let!(:foods) { create_list(:food, 8) }
    let!(:categories) { create_list(:category, 8) }

    before do
      get :index
    end

    it "assigns @foods" do
      expect(assigns(:foods)).to match_array(foods.sort_by(&:created_at).reverse)
    end
    
    it "assigns @pagy" do
      expect(assigns(:pagy)).not_to be_nil
    end

    it "assigns @categories" do
      expect(assigns(:categories)).to match_array(Category.category_sort)
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let!(:food) { create(:food) }

    context "when the food exists" do
      before do
        get :show, params: { id: food.id }
      end

      it "assigns @food" do
        expect(assigns(:food)).to eq(food)
      end

      it "assigns @item_avaiable_add" do
        expect(assigns(:item_avaiable_add)).to eq(food.available_item)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when the food does not exist" do
      before do
        get :show, params: { id: -1 }
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash danger message" do
        expect(flash[:danger]).to eq(I18n.t("foods.errors.food_not_found"))
      end
    end
  end
end
