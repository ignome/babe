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

  after :remove, :delete_store_dir

  def delete_store_dir
    FileUtils.rmdir store_dir
  end

end