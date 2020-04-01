class CardController < ApplicationController
  # show・edit・update・destroyアクションを呼ぶ前にset_cardメソッドを読む
  before_action :set_card, only: %i(show edit update destroy)

  def new
    @card = Card.new
    @list = List.find_by(id: params[:list_id])
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to :root
    else
      render action: :new
    end
  end

  # show・edit・update・destroyアクションを呼ぶ前にset_cardメソッドを読む
  def show
  end

  # show・edit・update・destroyアクションを呼ぶ前にset_cardメソッドを読む
  def edit
    # 登録されているリスト一覧を取得し、プルダウンで表示する。
    @lists = List.where(user: current_user)
  end

  # show・edit・update・destroyアクションを呼ぶ前にset_cardメソッドを読む
  def update
    if @card.update_attributes(card_params)
      redirect_to :root
    else
      render action: :edit
    end
  end

  # show・edit・update・destroyアクションを呼ぶ前にset_cardメソッドを読む
  def destroy
    @card.destroy
    redirect_to :root
  end

  private
    def card_params
      params.require(:card).permit(:title, :memo, :list_id)
    end

    def set_card
      @card = Card.find_by(id: params[:id])
    end

end
