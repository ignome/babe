class Page < ActiveRecord::Base
  belongs_to :catalog

  validates_presence_of :title, :body

  scope :recent, -> {order('updated_at desc')}
end
