class CoverUploader < BaseUploader
  
  def store_dir
    if is_ad?
      "ad/#{model.id}"
    else
      "users/#{model.user_id}/item/#{model.id}"
    end
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

  version :default do
    process :resize
  end

  def is_ad?
    model.instance_of?(Ad) ? true : false
  end

  def resize
    manipulate! do |img|
      if is_ad?
        img.resize!(model.position.width, model.position.height)
      else
        w = 215
        r = w / img.rows
        h = r * img.columns
        img.resize_to_fit!(w, h)
      end
    end
  end

end