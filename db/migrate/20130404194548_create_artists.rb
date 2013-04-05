class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :type
      t.integer :likes

      t.timestamps
    end
  end
end
