class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.boolean :approved

      t.timestamps
    end
  end
end
