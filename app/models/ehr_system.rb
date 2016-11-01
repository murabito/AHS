class EhrSystem < ActiveRecord::Base
  has_many :patients
  has_many :clinical_summaries
end
