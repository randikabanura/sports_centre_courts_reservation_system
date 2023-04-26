require 'rails_helper'

RSpec.describe "Api::V1::Reservations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/reservation/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/reservation/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/reservation/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /shoe" do
    it "returns http success" do
      get "/api/v1/reservation/shoe"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/reservation/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
