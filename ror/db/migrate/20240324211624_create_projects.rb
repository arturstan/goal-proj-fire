class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :area, null: true, foreign_key: true
      t.references :goal, null: true, foreign_key: true
      t.string :name
      t.string :description
      t.integer :hierarchy
      t.integer :status
      t.date :start_date
      t.date :due_date
      t.boolean :star

      t.timestamps
    end
  end
end
