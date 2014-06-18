class PhotoUploader < BaseUploader
  
  def store_dir
    "users/#{model.user_id}/#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

  version :default do
    process :resize_to_size
  end
  
  def resize_to_size
    manipulate! do |img|
      if model.instance_of? Ad
        img.resize!(model.position.width, model.position.height)
      else
        w = 215
        r = w / img[:width]
        h = r * h
        img.resize! "#{width}x#{height}"
      end
    end
  end
end
