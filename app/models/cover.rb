#coding: utf-8
require 'RMagick'

class Cover < ActiveRecord::Base
  # Share the same table with Photo, For easy saving cover from remote host
  self.table_name = 'photos'
  belongs_to :subject, polymorphic: true


  mount_uploader :file, CoverUploader

  after_save :pick_up_colors

  def pick_up_colors
    img = Magick::Image.read(self.file.default.path).first.quantize(8)
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

    self.update_column('colors', colors.join(';'))
    Color.create news
  end

end