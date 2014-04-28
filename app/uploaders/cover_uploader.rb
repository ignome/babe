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
    process :resize_to_fill => [150,200]
  end

  #process :pick_colors_up
end
