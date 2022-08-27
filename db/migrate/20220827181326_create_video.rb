class CreateVideo < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.text :description
      t.string :url, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
