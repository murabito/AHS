class AddSexToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :sex, :string
  end
end
