class RecentView < ActiveRecord::Base
  belongs_to :user
  belongs_to :clinical_summary
end
