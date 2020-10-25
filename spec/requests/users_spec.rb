require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    # subject { get(users_path) }

    it " ユーザーの一覧が取得できる " do
      # binding.pry
      # subject
      # get users_path
    end
  end

  describe "GET /users/:id" do
    it " 任意のユーザーのレコードが取得できる " do
    end
  end

  describe " POST /users " do
    it " ユーザーのレコードが作成できる " do
    end
  end

  describe " PATCH /users/:id " do
    it " 任意のユーザーのレコードを更新できる " do
    end
  end

  describe " DELETE /users/:id " do
    it " 任意のユーザーのレコードを更新できる " do
    end
  end
end
