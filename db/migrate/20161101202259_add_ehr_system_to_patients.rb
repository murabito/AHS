class AddEhrSystemToPatients < ActiveRecord::Migration
  def change
    add_reference :patients, :ehr_system, index: true, foreign_key: true
  end
end
