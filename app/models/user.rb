class User < ApplicationRecord

  # Userモデル側が１，Listモデル側が多。削除されるときは関連して削除する。
  has_many :lists, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # バリデーションを設定　
  validates :name, presence: true, length: { maximum: 20 }
end
