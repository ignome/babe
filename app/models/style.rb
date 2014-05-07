class Style < ActiveRecord::Base
  
  attr_accessor :photo, :item

  has_many :items_of_style
  has_many :items, :through => :items_of_style
  has_many :photos, :as => :subject
  has_many :comments, :as => :subject

  belongs_to :user

  validates_presence_of :photo
  validates_presence_of :body

  scope :last, ->{order('id desc')} 

  after_create :binding_photos_to_this
  after_create :binding_items_to_this

  def binding_photos_to_this
    if self.photo and self.photo.has_key?(:id) and self.photo[:id].is_a?(Array)
      Photo.update_all({subject_id: self.id, subject_type: 'Style'}, ["id in (?)", self.photo[:id]])
    end
  end

  def binding_items_to_this
    if self.item and self.item.has_key?(:id) and self.item[:id].is_a?(Array)
      news = self.item[:id].map{ |id| {style_id: self.id, item_id: id} }
      ItemsOfStyle.create news
    end
  end

  def who_liked user
  end
end
