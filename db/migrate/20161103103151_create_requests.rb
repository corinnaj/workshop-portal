class CreateRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :requests do |t|
      t.string :topics
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
