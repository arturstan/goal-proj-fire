class RemoveIsDefaultFromAreas < ActiveRecord::Migration[7.1]
  def change
    remove_column :areas, :isDefault, :boolean
  end
end
