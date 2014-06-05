class Promotion < ActiveRecord::Base

  scope :today, ->{ where(['created_at >= ?', Date.today.beginning_of_day.utc])}
end
