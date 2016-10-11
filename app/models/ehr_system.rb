class EhrSystem < ActiveRecord::Base
  has_many :clinical_summaries
end
