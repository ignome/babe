class Promotion < ActiveRecord::Base

  scope :today, ->{ where(['created_at >= ?', Date.today.beginning_of_day.utc])}
  scope :pins, ->{where('status > 0')}
end
