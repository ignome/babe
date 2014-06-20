class Ad < ActiveRecord::Base

  belongs_to :position
  
  validates_presence_of :title, :position_id, :url

  mount_uploader :cover, CoverUploader

  scope :recent, ->{ order('id desc') }
  scope :available, ->{ where(available: true) }

  # For uploader to get the size of position!
  def position
    if self.new_record?
      self.position = Position.find(self.position_id)
    else
      super
    end
  end

end
