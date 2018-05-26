class AddOptionsToField < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :options, :string
  end
end
