class TopController < ApplicationController
  def index
    # ログインしている自分のリストを取得
    @lists = List.where(user: current_user).order("created_at ASC")
  end
end
