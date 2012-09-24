class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :req_type
      t.string :params

      t.timestamps
    end
  end
end
