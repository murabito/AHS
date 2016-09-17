class Patient < ActiveRecord::Base
  has_many :clinical_summaries
end