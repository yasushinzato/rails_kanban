class UserController < ApplicationController
  # edit・updateアクションを呼ぶ前にset_userメソッドを読み込む
  before_action :set_user, only: %i(edit update)

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to :root
    else
      render action :edit
    end
  end

  private

    def user_params
      # params 送られてきたリクエスト情報をひとまとめにしたもの
      # require 受け取る値のキーを設定
      # permit 変更を加えられるキーを指定
      # merge 2つのハッシュを統合するメソッド
      params.require(:user).permit(:name)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end

end
