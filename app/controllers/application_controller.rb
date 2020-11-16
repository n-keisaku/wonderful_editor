class ApplicationController < ActionController::Base
  # すべての子コントローラーが Concerns(懸念事項) を include(含む) する
  include DeviseTokenAuth::Concerns::SetUserByToken
end
