#coding: utf-8

class AvatarUploader < BaseUploader

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "users/#{model.id}/#{mounted_as}"
  end

  version :normal do
    process :resize_to_fill => [48, 48]
  end

  version :small do
    process :resize_to_fill => [16, 16]
  end

  version :large do
    process :resize_to_fill => [64, 64]
  end

  version :big do
    process :resize_to_fill => [80, 80]
  end

  def default_url
    "avatar/#{version_name}.jpg"
  end
  
  def filename
    if super.present?
      "#{model.id}.#{file.extension.downcase}"
    end
  end

end
