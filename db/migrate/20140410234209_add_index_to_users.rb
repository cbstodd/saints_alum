class AddIndexToUsers < ActiveRecord::Migration
  # To keep a user from signing up with same email twice. 
  # Also allows us to do a fulltable-scan to find users email's. 
  def change
    add_index :users, :email, unique: true
  end
end
