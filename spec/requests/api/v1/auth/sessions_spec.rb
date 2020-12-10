require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録されているユーザーの情報が送信されたとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "ログインできる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが一致しないとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "hoge", password: user.password) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "passwordが一致しないとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "hoge") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_in" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログアウトに必要な情報が送信されたとき" do
      # ログインしているとき
      # ログアウトしようとした場合、ログアウトAPIを呼び出すと、成功する

      # ログインに必要なヘッダー情報
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }
      it "有効なトークン情報が無くなりログアウトする" do
        # subject を実行してトークンを再取得すると、トークン有り(true)からトークン無し(false)に変化する
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログアウトに間違った情報が送信されたとき" do
      # ログインしていないとき
      # ログアウトしようとした場合、ログアウトAPIを呼び出すと、失敗する

      # 認証ヘッダー["access-token","client","expiry","uid"]
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      let!(:headers) { { "access-token" => "", "client" => "", "expiry" => "", "uid" => "" } }
      it "ログアウトできない" do
        # 持っているトークンに変化がないこと
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
