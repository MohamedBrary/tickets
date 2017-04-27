class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :type

      t.timestamps
    end

    add_index :users, :type
  end
end
