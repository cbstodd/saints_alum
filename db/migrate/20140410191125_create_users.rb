class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :year 
      t.string :name
      t.string :email
      t.text :profile_info

      t.timestamps
    end
  end
end
