Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'

  # resourcesメソッドで、7つのアクション（index,new,create,show,edit,update,destroy）のルーティングを作成. onlyでアクションのルーティング追加を絞り込む
  resources :list, only: %i(new create edit update destroy) do
    # cardはlistの子になる。indexアクション以外は全部作成する。
    resources :card, except: %i(index)
  end


  # ユーザの氏名情報変更
  resources :user, only: %i(edit update)

end
