require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "When an existing user login" do
    it "should login" do
      dave = admins(:one)
      post :create, :name=>dave.name, :password=>'secret'
      assert_redirected_to home_index_url
      expect(session[:user_id]).to eq(dave.id)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
