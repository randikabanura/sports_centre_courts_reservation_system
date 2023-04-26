require 'rails_helper'

RSpec.describe "Api::V1::Courts", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/court/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/court/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/court/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/court/index"
      expect(response).to have_http_status(:success)
    end
  end

end
