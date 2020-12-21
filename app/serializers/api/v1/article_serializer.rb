class Api::V1::ArticleSerializer < ActiveModel::Serializer
  # 出力するカラムの指定
  attributes :id, :title, :body, :status, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
