class AddSerialNumberToVhs < ActiveRecord::Migration[5.2]
  def change
    add_column :vhs, :serial_number, :string
  end
end
