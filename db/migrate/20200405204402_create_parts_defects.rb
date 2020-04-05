class CreatePartsDefects < ActiveRecord::Migration[5.2]
  def change
    create_table :parts_defects do |t|
      t.boolean :wheels
      t.boolean :chassis
      t.boolean :laser
      t.boolean :computer
      t.boolean :engine
      t.boolean :seats
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
