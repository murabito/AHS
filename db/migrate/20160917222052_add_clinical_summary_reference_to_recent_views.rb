class AddClinicalSummaryReferenceToRecentViews < ActiveRecord::Migration
  def change
    add_reference :recent_views, :clinical_summary, index: true, foreign_key: true
  end
end
