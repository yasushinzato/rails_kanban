class List < ApplicationRecord
  # User側が１，List側が多。
  belongs_to :user

  # List側が１，Card側が多。
  has_many :cards, dependent: :destroy

  validates :title, length: { in: 1..255 }
end
