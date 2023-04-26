class CreateCourts < ActiveRecord::Migration[7.0]
  def change
    create_table :courts do |t|
      t.string :name
      t.integer :court_type, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
