class Position < ActiveRecord::Base
  
  has_many :ads

  validates_presence_of :title
  validates :slug, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :recently, ->{order('id desc')}

end
