class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :nist_id, index: true
      t.string :first_name
      t.string :last_name
      t.string :ssn, index: true
      t.string :dob
    end
  end
end
