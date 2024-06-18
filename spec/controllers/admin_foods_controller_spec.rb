require "rails_helper"

RSpec.describe Admin::FoodsController, type: :controller do
  let(:foods) { create_list(:food, 8) }
  let(:user) { create(:user, role: 0) }
  let(:category) { create(:category) }
  let(:food) { create(:food, category: category) }
  let(:valid_attributes) { attributes_for(:food, category_id: category.id) }
  let(:invalid_attributes) { attributes_for(:food, name: nil) }

  before do
    user.confirm
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Food" do
        expect {
          post :create, params: { food: valid_attributes }
        }.to change(Food, :count).by(1)
      end

      it "redirects to the created food" do
        post :create, params: { food: valid_attributes }
        expect(response).to redirect_to(admin_foods_path)
      end
    end

    context "with invalid params" do
      it "returns a success response to root path" do
        post :create, params: { food: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: food.to_param }
      expect(response).to be_successful
    end

    it "redirects to index with flash message when food not found" do
      get :show, params: { id: -1 }
      expect(response).to redirect_to(admin_foods_path)
      expect(flash[:danger]).to eq(I18n.t("admin.foods.errors.food_not_found"))
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: food.to_param }
      expect(response).to be_successful
    end

    it "redirects to index with flash message when food not found" do
      get :edit, params: { id: -1 }
      expect(response).to redirect_to(admin_foods_path)
      expect(flash[:danger]).to eq(I18n.t("admin.foods.errors.food_not_found"))
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "update name" } }

      it "updates the requested food" do
        put :update, params: { id: food.to_param, food: new_attributes }
        food.reload
        expect(food.name).to eq("update name")
      end

      it "redirects to the food" do
        put :update, params: { id: food.to_param, food: new_attributes }
        expect(response).to redirect_to(admin_food_path(id: food.id))
      end
    end

    context "with invalid params" do
      it "returns a success response when invalid" do
        put :update, params: { id: food.to_param, food: invalid_attributes }
        expect(response).to be_successful
      end
    end

    it "redirects to index with flash message when food not found" do
      put :update, params: { id: -1, food: valid_attributes }
      expect(response).to redirect_to(admin_foods_path)
      expect(flash[:danger]).to eq(I18n.t("admin.foods.errors.food_not_found"))
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested food" do
      food_to_destroy = create(:food)
      expect {
        delete :destroy, params: { id: food_to_destroy.to_param }
      }.to change(Food, :count).by(-1)
    end

    it "redirects to the foods list" do
      delete :destroy, params: { id: food.to_param }
      expect(response).to redirect_to(admin_foods_path)
    end

    it "redirects to index with flash message when food not found" do
      delete :destroy, params: { id: -1 }
      expect(response).to redirect_to(admin_foods_path)
      expect(flash[:danger]).to eq(I18n.t("admin.foods.errors.food_not_found"))
    end
  end
end
