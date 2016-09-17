class RemovePatientIdFromRecentView < ActiveRecord::Migration
  def change
    remove_reference :recent_views, :ehr_system, index: true
    remove_reference :recent_views, :patient, index: true
  end
end
