class PhotoUploader < BaseUploader
  
  def store_dir
    "users/#{model.user_id}/#{model.subject_type.to_s.downcase}/#{model.subject_id}"
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

end