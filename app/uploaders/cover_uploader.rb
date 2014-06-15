class CoverUploader < BaseUploader
  
  def store_dir
    "users/#{model.user_id}/#{model.subject_type.downcase}/#{model.subject_id}"
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

  version :default do
    #process :resize_to_fill => [215,200]
    process :resize_by_width
  end

  def resize_by_width
    manipulate! do |img|
      w = 215
      r = w / img[:width]
      h = r * h
      img.resize! "#{width}x#{height}"
    end
  end

end