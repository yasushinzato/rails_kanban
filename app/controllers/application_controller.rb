class ApplicationController < ActionController::Base
  # クロスサイトリクエストフォージェリ（CSRF)への対策コード
  protect_from_forgery with: :exception
  # サインインしていないときはサインインページにリダイレクトする。
  before_action :authenticate_user!
  # devise_controllerのときだけnameカラム追加用のメソッドを実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    # nameカラムを追加用メソッド
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
  
end
