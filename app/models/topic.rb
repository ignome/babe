class Topic < ActiveRecord::Base
  attr_accessor :photo

  belongs_to :node, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :photos, :as => :subject
  has_many :comments, :as => :subject

  validates_presence_of :user_id, :title, :body, :node_id

  after_save :binding_photo_to_this

  scope :fields_in_list, -> { select(Topic.attribute_names - ['body']) }

  protected

  def binding_photo_to_this
    if self.photo and self.photo.has_key?(:id) and self.photo[:id].is_a?(Array)
      Photo.update_all({subject_id: self.id, subject_type: 'Topic'}, ["id in (?)", self.photo[:id]])
    end
  end
end
