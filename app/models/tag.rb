class Tag < ActiveRecord::Base
  has_many :items_of_tags, :dependent => :delete_all
  has_many :items, :through => :items_of_tags

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end