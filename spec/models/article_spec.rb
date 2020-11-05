# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
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

  context " title, body, user_id が登録されたとき " do
    it " 記事が登録できる "do
    user = create(:user)
    article = user.articles.build(
      title: "title",
      body: "body",
      user_id: 1
    )
    expect(article).to be_valid
    end
  end

end
# rubocop:enable all
