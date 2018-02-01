class CreateImports < ActiveRecord::Migration[5.1]
  def change
    create_table :imports do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :nbr_import, default: 0
      t.string :reason, default: nil
      t.timestamps
    end
  end
end
