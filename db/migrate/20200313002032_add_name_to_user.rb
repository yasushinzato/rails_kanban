class AddNameToUser < ActiveRecord::Migration[5.2]
  def change
    # add_column :users, :name, :string
    # NotNull制約を追加する
    add_column :users, :name, :string, null: false, default: ""
  end
end
