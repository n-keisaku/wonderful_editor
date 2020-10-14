class CreateArticleLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :article_like do |t|
      t.references :articles, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
