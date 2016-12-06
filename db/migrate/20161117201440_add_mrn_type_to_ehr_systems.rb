class AddMrnTypeToEhrSystems < ActiveRecord::Migration
  def change
    add_column :ehr_systems, :mrn_type, :string
  end
end
