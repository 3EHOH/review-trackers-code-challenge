class CreateRelease < ActiveRecord::Migration[5.1]
  def change
    create_table :release do |t|
      t.text :goal_summary
      t.integer :team_id
      t.string :product_owner

      t.timestamps
    end
  end
end
