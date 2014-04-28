#coding:utf-8
class Photo < ActiveRecord::Base
  
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :subject, polymorphic: true

  mount_uploader :file, PhotoUploader

  scope :recent, Proc.new { |last| order('id desc').limit(last || 4) }

  before_create do
    self.name = file.file.original_filename
    #self.size = file.file.size
  end

  def to_jq_upload
    {
      "id"    => self.id,
      "name"  => self.name,
      "url"   => self.file.url,
      "thumbnail_url" => self.file.default.url
      #"size"  => self.size,
      #"delete_url"  => photo_path(:id => id),
      #"delete_type" => "DELETE"
    }
  end
end
