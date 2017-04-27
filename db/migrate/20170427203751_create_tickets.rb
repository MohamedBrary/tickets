class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.text :desc
      t.text :report
      t.references :customer, foreign_key: true
      t.references :agent, foreign_key: true
      t.integer :status
      t.time :resolution_date

      t.timestamps
    end
  end
end
