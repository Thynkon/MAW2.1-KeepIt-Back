require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /all" do
    it "returns http success" do
      get "/api/books"
      expect(response).to have_http_status(:success)
    end
  end

end
