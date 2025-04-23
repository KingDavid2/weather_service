class CreateWeathers < ActiveRecord::Migration[8.0]
  def change
    create_table :weathers do |t|
      t.float :lat
      t.float :lon
      t.jsonb :data
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
