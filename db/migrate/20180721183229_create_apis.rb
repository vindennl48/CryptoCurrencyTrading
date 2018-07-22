class CreateApis < ActiveRecord::Migration[5.2]
  def change
    create_table :apis do |t|
      t.string :api_key
      t.string :secret_key

      t.timestamps
    end
  end
end
