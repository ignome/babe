class ItemsOfStyle < ActiveRecord::Base
  belongs_to :style
  belongs_to :item
end
