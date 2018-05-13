class CreateVieweds < ActiveRecord::Migration[5.1]
  def change
    create_table :vieweds do |t|

      t.timestamps
    end
  end
end
