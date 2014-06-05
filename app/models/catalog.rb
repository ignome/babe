class Catalog < ActiveRecord::Base
  
  has_many :pages
  has_many :child, foreign_key: 'parent_id', class_name: 'Catalog'
  belongs_to :parent, class_name: 'Catalog', counter_cache: 'childs'

  validates_presence_of :name
  validates :slug, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :roots, ->{where('parent_id=0')}
  scope :about, ->{find_by(slug: "about")}

end
