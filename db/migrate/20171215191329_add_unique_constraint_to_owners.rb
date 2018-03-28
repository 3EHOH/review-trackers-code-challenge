class AddUniqueConstraintToOwners < ActiveRecord::Migration[5.1]
  def change
    add_index(:owners, [:poid], unique: true)
  end
end
