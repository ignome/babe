#coding:utf-8
class Photo < ActiveRecord::Base
  
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :subject, polymorphic: true
  has_many :colors, :dependent => :delete_all

  mount_uploader :file, PhotoUploader

  scope :recent, Proc.new { |last| order('id desc').limit(last || 4) }
  scope :old, ->{where(:new, false)}

  before_create do
    self.name = file.file.original_filename
    #self.size = file.file.size
  end

  # Apply to item only
  #after_create :pick_colors_up
  def pick_colors_up
    if self.subject_type.to_s.downcase == 'item'
      img = Magick::Image.read(self.file.path).first.quantize(8)
      # memory warning!!!
      his = img.color_histogram()
      # sort by times appeared in image
      pixels = 0
      sorted = his.sort_by{ |k,v| pixels += v; v }
      colors = []
      news   = []
      pixels = pixels.to_f

      sorted.reverse.each do |pixel|
        r = pixel[0].red    >> 8
        g = pixel[0].green  >> 8
        b = pixel[0].blue   >> 8
        p = (pixel[1] / pixels).round(2)
        h = "%02X%02X%02X" % [ r, g , g ]
        colors << h
        next unless p < 0.1
        news << {photo_id: self.id, hex: h, r: r, g: r, b: b, percent: p}
      end

      self.update_column('color', colors.join(';'))
      Color.create news
    end
  end

  def to_jq_upload
    {
      "id"    => self.id,
      "name"  => self.name,
      "link"   => self.file.url,
      "thumbnail_url" => self.file.default.url
      #"size"  => self.size,
      #"delete_url"  => photo_path(:id => id),
      #"delete_type" => "DELETE"
    }
  end
end
