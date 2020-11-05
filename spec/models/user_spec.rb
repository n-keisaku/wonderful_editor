require "rails_helper"

RSpec.describe User, type: :model do
  context " 必要な情報がそろっているとき" do
    let(:user) { build(:user) }

    it " ユーザーが登録できる" do
      expect(user).to be_valid
    end
  end

  context " 名前のみ入力したとき " do
    let(:user) { build(:user, email: nil, password: nil) }

    it " ユーザー登録に失敗する " do
      expect(user).not_to be_valid
    end
  end

  context " email が無いとき " do
    let(:user) { build(:user, email: nil) }

    it " ユーザー登録に失敗する " do
      expect(user).not_to be_valid
    end
  end

  context " password が無いとき " do
    let(:user) { build(:user, password: nil) }

    it " ユーザー登録に失敗する " do
      expect(user).not_to be_valid
    end
  end

  context " 同じ email が登録されているとき" do
    let(:user1) { create(:user) }
    let(:user2) { build(:user, email: user1.email) }

    it " user 登録に失敗する" do
      user2.valid?
      # build(:user, email:"foo@example.com")
      # user = build(:user, email:"foo@example.com")
      # expect(user).to be_inbalid
      expect(user2.errors.messages[:email]).to include "has already been taken"
    end
  end
end
