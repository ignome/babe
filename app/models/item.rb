class Item < ActiveRecord::Base
  # For keeping the URL to download by sidekiq in backen!
  attr_accessor :urls

  belongs_to :user, counter_cache: true
  belongs_to :category
  
  has_many :fans_of_items
  has_many :fans, :through => :fans_of_items, source: :user
  has_many :comments, as: :subject
  has_many :covers, as: :subject

  #mount_uploader :cover, CoverUploader

  scope :fields_in_list, -> { select(Item.attribute_names - ['body']) }
  scope :recent, Proc.new { |last| order('id desc').limit(last || 4) }
  
end
