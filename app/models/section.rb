class Section < ActiveRecord::Base

  has_many :nodes, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def sorted_nodes
    self.nodes.sorted
  end
end