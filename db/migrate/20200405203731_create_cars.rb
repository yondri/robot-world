class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.integer :assembly_step, default: 0
      t.string :year
      t.integer :status, default: 0
      t.decimal :price
      t.decimal :cost_price
      t.references :car_model, foreign_key: true

      t.timestamps
    end
  end
end
