# Rails の勉強で、Kanban を作成。

## 環境

- Windows10
- ruby 2.5.1p57
- Rails 5.2.4.1
- node v12.16.1

※Ruby のインストールでミラーサイトからの DL ができなくてエラーになることが頻発した。
朝方に再度インストールを実行すると正常に行えた。

## 説明

かんばんによる簡易 ToDo リストを作成
SQLite3 なので、DB 構築は特に必要なく使用できる。
画像はあとで貼る。

### Ruby on Rails インストール

SQLite3 のインストール
https://sqlite.org/download.html　から以下の 2 つの zip を DL し、
sqlite-dll-win64-x64-3310100.zip
sqlite-tools-win32-x86-3310100.zip
以下のファイルを Ruby インストールフォルダの bin フォルダにコピーする

- sqlite3.dll
- sqlite3.exe

以下のコマンドを実行し、Rails のインストール
`gem install rails -v "5.2.3"`

### Bootstrap の導入

Gemfiles に以下を追記する。
gem 'bootstrap', '~> 4.4.1'
gem 'jquery-rails'
その後は bundle install する。
以下の scss ファイルは存在しない(同名称で css 拡張子ファイルはある)ので、css 拡張子を変更しておく。
app
└── assets
└── stylesheets
└── application.scss
ファイルにインポートして使用できるようにする。

```css:application.scss
@import "bootstrap";
```

application.js に以下の 3 行のコードを追加します。

//= require jquery3
//= require popper
//= require bootstrap-sprockets
注意点として、すでにかかれている以下のコードが一番下になるように、追記。

//= require require_tree .

理由としては、require_tree .は現在のディレクトリにある全ての JavaScript ファイルを読み込むから。jquery3 などのコードが先に読み込まれてからでないと、エラーが起きる可能性あり。

**Windows の場合は Node をインストールし、config の boot.rb に追記が必要**
`ENV['EXECJS_RUNTIME'] = 'Node'`

コマンドプロンプトは再起動すること。じゃないと Node の設定をしていないときと同じ ExcecJS エラーが発生する。

### アイコン（font-awesome-saas）の導入

gem に include

```ruby:Gemfile
gem 'font-awesome-sass', '~> 5.9.0'
```

gem を反映するため、`bundle install`

**FontAwesome の style を import する**
app
└── assets
└── stylesheets
└── application.scss

```css:application.scss
@import "bootstrap";

@import "font-awesome-sprockets";
@import "font-awesome";

@import "custom";
```

### Devise 導入

ユーザ登録、ログイン機能などの認証を簡単に追加できる Rails 用 gem
gem に include

```ruby:Gemfile
gem devise
```

gem を反映するため、`bundle install`
続いて、`rails generate devise:install`
実行すると、以下のファイルが作られる。

```
create  config/initializers/devise.rb
create  config/locales/devise.en.yml
```

#### Devise のフラッシュメッセージを追加

成功・失敗のメッセージを表示する。

```ruby:application.html.erb
  <body>
    <%= render 'partial/header' %>

    <%# ==========ここから追加する========== %>
    <% if flash[:notice] %>
      <div class="alert alert-info">
        <%= flash[:notice] %>
      </div>
    <% end %>
    <% if flash[:alert] %>
      <div class="alert alert-danger">
        <%= flash[:alert] %>
      </div>
    <% end %>
    <%# ==========ここまで追加する========== %>

    <%= yield %>
  </body>
```

#### Devise のビューファイルをインストール

`rails g devise:views` コマンドで view ファイルを生成する。

#### User モデルを作成

`rails g devise User`

#### Users テーブルを作成

User モデル作成時に db/migrate フォルダにマイグレーションファイルが作成された。
そのマイグレーションファイルを実行して DB に反映させる。  
`rails db:migrate`

#### サインインしてないならヘッダーを非表示

```ruby:application.html.erb
  <body>
    <%# この行にif式を追加する %>
    <%= render 'partial/header' if current_user %>
```

#### users テーブルに name カラムを追加

name カラムは string 型に指定。
`rails g migration AddNameToUser name:string`
name は入力必須とするので、ファイルを以下の通り修正する。
db
└── migrate
└── xxxxxx_add_name_to_user.rb

```ruby
class AddNameToUser < ActiveRecord::Migration[5.2]
  def change
    # add_column :users, :name, :string
    # NotNull制約を追加する
    add_column :users, :name, :string, null: false, default: ""
  end
end
```

マイグレーションファイルを更新したら、DB へ反映させる。
`rails db:migrate`

#### バリデーションの設定

app
└── models
└── user.rb

```ruby:user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # バリデーションを設定　
  validates :name, presence: true, length: { maximum: 20 }
end
```

#### 登録時に name カラムを保存できるようにする

Devise のデフォルトがメールアドレスとパスワードだけなので、name も登録できるようにする。

```ruby:application_controller.rb
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
```

### Windows で db:reset できない。

なので、sqlite3 ファイルを手動で削除してから setup コマンドを実行して reset の変わりとする。
$ del db/development.sqlite3
$ rails db:setup
