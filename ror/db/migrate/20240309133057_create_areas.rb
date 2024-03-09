class CreateAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :areas do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :hierarchy
      t.boolean :isDefault

      t.timestamps
    end
  end
end
