class EhrSystem < ActiveRecord::Base
  has_many :recent_views
  has_many :clinical_summaries
end
