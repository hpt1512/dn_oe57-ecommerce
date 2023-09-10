class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.integer :quantity
      t.integer :rating
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end