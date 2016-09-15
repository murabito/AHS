class RecentView < ActiveRecord::Base
  belongs_to :user
  belongs_to :patient
  belongs_to :ehr_system
end
