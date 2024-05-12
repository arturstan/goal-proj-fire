class CreateGoalComments < ActiveRecord::Migration[7.1]
  def change
    create_table :goal_comments do |t|
      t.text :comment
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
