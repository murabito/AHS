class CreateRecentViews < ActiveRecord::Migration
  def change
    create_table :recent_views do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :patient, index: true, foreign_key: true
      t.belongs_to :ehr_system, index: true, foreign_key: true
      t.boolean :is_saved, index: true, default: false

      t.timestamps null: false
    end
  end
end
