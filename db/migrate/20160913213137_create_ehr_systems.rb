class CreateEhrSystems < ActiveRecord::Migration
  def change
    create_table :ehr_systems do |t|
      t.string :redox_id
      t.string :name

      t.timestamps null: false
    end
  end
end
