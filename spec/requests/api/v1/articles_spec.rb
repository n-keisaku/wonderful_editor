require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published) }

    # 公開されている記事だけ取得できる
    # 記事を作成する時に、記事の公開・非公開を選択できる
    it "公開されている記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "指定した記事が公開されているとき" do
        let(:article) { create(:article, :published) }

        it "その記事のレコードが取得できる" do
          subject
          res = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)

          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end
    end

    context "指定した id の記事が存在しないとき" do
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    # before {} 事前に走らせたい処理を書く
    # スタブ allow(モックオブジェクト).to receive(メソッド名).and_return(返したい値)
    # クラスメソッド allow(Class).to receive(:target_method).and_return('mock_value')
    # インスタンスメソッド allow_any_instance_of(Class).to receive(:target_method).and_return('mock_value')
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "公開指定で記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, :published) } }

      it "記事のレコードを作成できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "下書指定で記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, :draft) } }

      it "下書き記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)
      end
    end

    context "公開・下書き指定以外で記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, status: :foo) } }

      it "エラーになる" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:headers) { current_user.create_new_auth_token }

    # 公開記事を更新したとき
    # 下書き記事を更新したとき
    context "自分の記事を更新したとき" do
      let!(:article) { create(:article, :draft, user: current_user) }

      it " 記事を更新できる" do
        # 変化をチェックするには change マッチャーを使う
        # 何から何に変わるかという書き方をする
        # change { X }.from(A).to(B)
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body]) &
                              change { article.reload.status }.from(article.status).to(params[:article][:status].to_s)
        expect(response).to have_http_status(:ok)
      end
    end

    context "他のユーザーの記事を更新しようとしたとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }
    # devise_token_auth の導入後に削除

    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の記事を削除しようとするとき" do
      let!(:article) { create(:article, user: current_user) }
      it "記事を削除できる" do
        expect { subject }.to change { Article.count }. by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他人が持っている記事を削除しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事が削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }. by(0)
      end
    end
  end
end
