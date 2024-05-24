class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :status
      t.boolean :star
      t.date :start_date
      t.date :due_date
      t.integer :energy
      t.integer :time
      t.references :user, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
