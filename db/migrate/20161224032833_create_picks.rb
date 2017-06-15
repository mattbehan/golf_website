class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|

    	t.belongs_to :pool, index: true, null: false
    	t.belongs_to :user, index: true, null: false
    	t.belongs_to :golfer

      t.timestamps null: false
    end
  end
end
