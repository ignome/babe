class TaskLink < ActiveRecord::Base
  scope :available, ->{ where("status=0") }
end
