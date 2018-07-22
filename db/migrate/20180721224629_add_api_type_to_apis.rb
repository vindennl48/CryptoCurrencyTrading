class AddApiTypeToApis < ActiveRecord::Migration[5.2]
  def change
    add_column :apis, :api_type, :string
  end
end
