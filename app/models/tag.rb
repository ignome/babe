class Tag < ActiveRecord::Base
  has_many :items_of_tags, :dependent => :delete_all
  has_many :items, :through => :items_of_tags

  belongs_to :category

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :keywords, ->{where(['available=? and searchable=?', true, true]).order('updated_at desc').limit(5)}
end
