class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :is_valid, default: false
      t.string :reason, default: nil
      t.integer :nbr_import, default: 0
      t.timestamps
    end
  end
end
