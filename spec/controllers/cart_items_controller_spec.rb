require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do

  describe "GET #create" do
    it "returns http success" do
      skip
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      skip
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
