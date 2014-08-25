class Bookmark < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :items_of_bookmarks
  has_many :items, :through => :items_of_bookmarks

  validates_presence_of :title
end