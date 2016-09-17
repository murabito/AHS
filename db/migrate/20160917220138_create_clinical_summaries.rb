class CreateClinicalSummaries < ActiveRecord::Migration
  def change
    create_table :clinical_summaries do |t|
      t.string :document_id
      t.belongs_to :patient, index: true, foreign_key: true
      t.belongs_to :ehr_system, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
