class AddSessionCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sessions_count, :integer
  end
end
