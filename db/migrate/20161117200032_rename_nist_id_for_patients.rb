class RenameNistIdForPatients < ActiveRecord::Migration
  def change
    rename_column :patients, :nist_id, :mrn
  end
end
