class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :type
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :username
      t.boolean :use_uid
      t.boolean :display_name
      t.string :city
      t.string :country
      t.boolean :display_location
      t.string :photo

      t.timestamps
    end
  end
end
