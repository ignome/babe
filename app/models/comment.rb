class Comment < ActiveRecord::Base
  
  belongs_to :subject, polymorphic: true, counter_cache: true
  belongs_to :user
  
end
