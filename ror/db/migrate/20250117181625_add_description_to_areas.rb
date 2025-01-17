class AddDescriptionToAreas < ActiveRecord::Migration[7.1]
  def change
    add_column :areas, :description, :text
  end
end
