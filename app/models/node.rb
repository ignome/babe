class Node < ActiveRecord::Base

  belongs_to :section

  validates_presence_of :name, :description, :section
  validates_uniqueness_of :name

  #has_and_belongs_to_many :followers, :class_name => 'User', :inverse_of => :following_nodes
  scope :hots, -> {order('topics_count desc')}
  scope :sorted, -> {order('sort asc')}

end
