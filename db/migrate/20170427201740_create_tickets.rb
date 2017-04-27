class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.text :desc
      t.text :report
      t.references :customer, index: true, foreign_key: { to_table: :users }
      t.references :agent, index: true, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end
