class ListController < ApplicationController
  # edit・update・destroyアクションを呼ぶ前にset_listメソッドを読み込む
  before_action :set_list, only: %i(edit update destroy)

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      # リストが作成できたらルートパスに遷移
      redirect_to :root
    else
      render action: :new
    end
  end

  # @listインスタンス変数はupdate・destroyメソッドでも使うので、共通化
  def edit
  end

  def update
    if @list.update_attributes(list_params)
      redirect_to :root
    else
      render action :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to :root
  end

  private
    def list_params
      # params 送られてきたリクエスト情報をひとまとめにしたもの
      # require 受け取る値のキーを設定
      # permit 変更を加えられるキーを指定
      # merge 2つのハッシュを統合するメソッド
      params.require(:list).permit(:title).merge(user: current_user)
    end

    # edit・update・destroy両方で使うので共通化
    def set_list
      @list = List.find_by(id: params[:id])
    end
end
