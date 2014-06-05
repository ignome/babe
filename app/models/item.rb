class Item < ActiveRecord::Base
  # For keeping the URL to download by sidekiq in backen!
  attr_accessor :urls, :comment

  belongs_to :user, counter_cache: true
  belongs_to :category
  
  has_many :fans_of_items
  has_many :fans, :through => :fans_of_items, source: :user
  has_many :comments, as: :subject
  has_many :covers, as: :subject

  #mount_uploader :cover, CoverUploader

  scope :fields_in_list, -> { select(Item.attribute_names - ['body']) }
  scope :recent, Proc.new { |last| order('id desc').limit(last || 4) }

  after_create :download_images_from_urls
  after_create :new_first_comment

  def download_images_from_urls
    self.urls.each do |url|
      cover = self.covers.new
      cover.file.download! url
      cover.user_id = self.user_id
      cover.save
      # Change the cover too!
      self.cover = cover.file.default.url
    end
    self.save
  end

  def new_first_comment
    unless self.comment.blank?
      comment = self.comments.new
      comment.body = self.comment
      comment.user_id = self.user_id
      comment.save
    end
  end
  
  def who_liked user
    self.fans.exists?(id: user)
  end

end
