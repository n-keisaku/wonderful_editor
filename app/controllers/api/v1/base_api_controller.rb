class Api::V1::BaseApiController < ApplicationController
  # current_user のダミーコード
  # def current_user
  #   # ||は@current_user が存在しないとき右辺を代入する
  #   @current_user ||= User.first
  # end
  # メソッドのエイリアスで別名を定義する alias_method 新メソッド名, 旧メソッド名
  alias_method :current_user, :current_api_v1_user
  alias_method :authenticate_user!, :authenticate_api_v1_user!
  alias_method :user_signed_in?, :api_v1_user_signed_in?
end
