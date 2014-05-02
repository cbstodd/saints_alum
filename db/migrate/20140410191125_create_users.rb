class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :year 
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
