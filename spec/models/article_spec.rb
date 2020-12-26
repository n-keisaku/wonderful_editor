# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"
# rubocop:disable all
RSpec.describe Article, type: :model do
  # context " title, body, user_id が登録されたとき " do
  #   it " 記事が登録できる "do
  #   user = create(:user)
  #   article = user.articles.build(
  #     title: "title",
  #     body: "body",
  #     user_id: 1
  #   )
  #   expect(article).to be_valid
  #   end
  # end

  # 下書き記事だけ取得できる
  # 公開記事だけ取得できる
  context " タイトルと本文が入力されているとき " do
    let(:article) { build(:article) }
    it " 記事の下書きが作成できる" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context " status が下書き状態のとき " do
    let(:article) { build(:article, :draft) }
    it " 記事を下書き状態で作成できる " do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context " status が公開状態のとき " do
    let(:article) { build(:article, :published) }
    it " 記事を公開状態で作成できる " do
      expect(article).to be_valid
      expect(article.status).to eq "published"
    end
  end

end
# rubocop:enable all
