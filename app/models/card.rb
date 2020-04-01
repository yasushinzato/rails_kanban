class Card < ApplicationRecord
  # List側が１，Card側が多。
  belongs_to :list

  validates :title, length: { in: 1..255 }
  validates :memo, length: { maximum: 1000 }

end
