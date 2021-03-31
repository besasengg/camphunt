class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :contract_code
      t.integer :park_id
      t.references :users, null: false, foreign_key: true
    end
  end
end
