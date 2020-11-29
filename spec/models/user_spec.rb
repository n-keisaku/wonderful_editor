# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
