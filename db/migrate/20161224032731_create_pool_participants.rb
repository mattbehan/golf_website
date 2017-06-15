class CreatePoolParticipants < ActiveRecord::Migration
  def change
    create_table :pool_participants do |t|

      t.timestamps null: false
      t.references :user, index: true, null: false
      t.references :pool, index: true, null: false
    end
  end
end
