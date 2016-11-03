class Patient < ActiveRecord::Base
  has_many :clinical_summaries
  belongs_to :ehr_system
end