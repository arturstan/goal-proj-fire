class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :area, null: true, foreign_key: true
      t.string :name
      t.string :description
      t.integer :hierarchy
      t.integer :status

      t.timestamps
    end
  end
end
