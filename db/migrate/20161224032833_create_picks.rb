class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|

    	t.belongs_to :pool, index: true, null: false
    	t.belongs_to :user, index: true, null: false
    	t.belongs_to :golfer, index: true
    	t.belongs_to :pool_participant, index: true

      t.timestamps null: false
    end
  end
end
