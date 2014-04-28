#coding: utf-8

class AvatarUploader < BaseUploader

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "users/#{model.id}/#{mounted_as}"
  end

  process :resize_to_fill => [80,80]
  
  def filename
    if super.present?
      "#{model.id}.#{file.extension.downcase}"
    end
  end

end
