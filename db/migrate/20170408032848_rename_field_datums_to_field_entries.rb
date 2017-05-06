class RenameFieldDatumsToFieldEntries < ActiveRecord::Migration[5.0]
  def change
    rename_table :field_datums, :field_entries
  end
end
