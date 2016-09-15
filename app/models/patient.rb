class Patient < ActiveRecord::Base
  has_many :recent_views
end