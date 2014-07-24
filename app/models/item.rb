
class Item < ActiveRecord::Base

  # For keeping the URL to download 
  attr_accessor :urls, :comment, :selected

  belongs_to :user, counter_cache: true
  belongs_to :category

  has_many :fans_of_items
  has_many :fans, :through => :fans_of_items, :source => :user
  has_many :items_of_tags
  has_many :tags, :through => :items_of_tags
  has_many :comments, :as => :subject
  has_many :photos, :as => :subject, :dependent => :destroy

  mount_uploader :cover, CoverUploader

  scope :fields_in_list, -> { select(Item.attribute_names - ['body']) }
  scope :recent, Proc.new { |last| order('id desc').limit(last || 4) }
  scope :pins, ->{where('status > 0')}

  before_create :parse_provider_and_iid
  after_create :download_images_from_urls
  after_create :new_first_comment

  def download_images_from_urls
    
    self.urls.each_with_index do |url, index|
      # avoid failing in some one of urls
      begin
        cover = self.photos.new
        cover.file.download! url
      rescue Exception => e
        Rails.logger.info e.message
        Rails.logger.info url
        next
      end
      cover.user_id = self.user_id
      cover.save
      # Pick first photo as cover!
      if index == self.selected.to_i
        Rails.logger.info "set cover #{cover.file.path}"
        self.cover = File.new(cover.file.path)
        self.save
      end
    end
  end

  def new_first_comment
    unless self.comment.blank?
      comment = self.comments.new
      comment.body = self.comment
      comment.user_id = self.user_id
      comment.save
    end
  end

  def parse_provider_and_iid
    self.provider = URI(self.url).hostname.split('.')[1].downcase
    self.iid = /(\d+)/.match(self.url)[1]
  end
  
  def self.parse url
    Provider::Base.parse(url)
  end


  def liked_by user
    self.fans.exists?(id: user)
  end

end
