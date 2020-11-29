class ApplicationController < ActionController::Base
  # すべての子コントローラーが Concerns(懸念事項) を include(含む) する
  include DeviseTokenAuth::Concerns::SetUserByToken
  # トークン認証のためCSRFは使わないので OFF にする
  protect_from_forgery with: :null_session
end
