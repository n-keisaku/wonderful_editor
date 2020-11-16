class Api::V1::BaseApiController < ApplicationController
  # current_user のダミーコード
  def current_user
    # ||は@current_user が存在しないとき右辺を代入する
    @current_user ||= User.first
  end
end
