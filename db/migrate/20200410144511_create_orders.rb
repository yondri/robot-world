class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.decimal :total
      t.decimal :cost_price
      t.integer :status, default: 0
      t.text :notes
      t.references :car, foreign_key: true, on_delete: :cascade
      t.references :car_model, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
