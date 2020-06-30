class AddForceDisplayToField < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :force_display, :boolean, default: false
  end
end
