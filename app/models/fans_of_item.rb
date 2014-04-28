class FansOfItem < ActiveRecord::Base

  belongs_to :user, counter_cache: 'likes_count'
  belongs_to :item, counter_cache: 'likes_count'

  scope :default, -> { select(FansOfItem.attribute_names - ['id']) }
end
