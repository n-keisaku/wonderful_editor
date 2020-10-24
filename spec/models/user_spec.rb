# rubocop:disable all
require "rails_helper"

RSpec.describe User, type: :model do

  context " 必要な情報がそろっているとき" do
    let (:user) { build(:user)}

    it " ユーザーが登録できる"do
    expect(user).to be_valid
    end
  end

  context " 名前のみ入力したとき " do
    let (:user) { build(:user, email: nil, password: nil) }

    it " ユーザー登録に失敗する " do
    expect(user).not_to be_valid
    end
  end

  context " email が無いとき " do
    let (:user) { build(:user, email: nil) }

    it " ユーザー登録に失敗する " do
    expect(user).not_to be_valid
    end
  end

  context " password が無いとき " do
    let (:user) { build(:user, password: nil) }

    it " ユーザー登録に失敗する " do
    expect(user).not_to be_valid
    end
  end

  context " 同じ email が登録されているとき" do
    it " user 登録に失敗する" do
      build(:user, email:"foo@example.com")
      user = build(:user, email:"foo@example.com")

      expect(user).to be_inbalid
    end
  end

end
# rubocop:enable all
