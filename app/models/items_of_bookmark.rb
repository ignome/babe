class ItemsOfBookmark < ActiveRecord::Base
  belongs_to :item, counter_cache: 'favorites_count'
  belongs_to :bookmark, counter_cache: 'items_count'
end
