class CreateProjectComments < ActiveRecord::Migration[7.1]
  def change
    create_table :project_comments do |t|
      t.text :comment
      t.references :project_id, null: false, foreign_key: true
      t.references :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
