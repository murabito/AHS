class RemoveFirstNameFromPatients < ActiveRecord::Migration
  def change
    remove_column :patients, :first_name, :string
    remove_column :patients, :last_name, :string
    remove_column :patients, :ssn, :string, index: true
    remove_column :patients, :dob, :string
  end
end
