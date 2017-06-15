class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|

      t.timestamps null: false
      t.string :name, null: false, index: true
      t.belongs_to :creator, index: true, null: false
      t.belongs_to :tournament, index: true, null: false
      t.string :pool_type
    end
  end
end
