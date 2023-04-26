class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :court, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :canceled, default: false
      t.text :notes, default: ''

      t.timestamps
    end
  end
end
