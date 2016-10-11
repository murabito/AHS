class ClinicalSummary < ActiveRecord::Base
  belongs_to :patient
  belongs_to :ehr_system
  has_many :recent_views
end
