class AddUserToApis < ActiveRecord::Migration[5.2]
  def change
    add_reference :apis, :user, foreign_key: true
  end
end
