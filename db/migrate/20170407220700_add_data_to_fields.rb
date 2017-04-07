class AddDataToFields < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :data, :string
  end
end
