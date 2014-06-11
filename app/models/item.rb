require 'nokogiri'

class Item < ActiveRecord::Base
  HOST = /^http:\/\/\w+\.(jd|tmall|taobao)\.com/
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

  def self.parse url
    uri = URI('http://localhost:8088/')
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('url' => url)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.read_timeout = 10 * 60 * 60
      http.request(req)
    end

    page = Nokogiri::HTML(res.body, nil, 'GBK')
    item = Item.new
    item.url = url

    if /jd\.com/.match url
      item.title = page.css('div#name h1').text.strip
      item.price = page.css('strong#jd-price').text.strip[1..-1]
      item.mprice = page.css('del#page_maprice').text.sub! /\D+/, ''
      images = page.css('div.spec-items ul.lh img')
      # Real 350px image
      host = images[0].attr('src').split('/')[2]
      # Reverse to keep the original order!
      item.urls = images.map{|img| "http://#{host}/n1/#{img.attr('data-url')}"}
      # Should get all pictures of description.
      item.body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
    
    
    elsif /taobao\.com/.match url
      # Fuck the long long url, cover to htt://taobao.com/item.html?id=id
      if item.url.length > 128
        id = item.url.match(/(id=\d+)/)[0]
        item.url = item.url.split('?')[0] << '?' << id
      end
      item.title = page.css('#J_Title h3').text.strip
      item.price = page.css('em.tb-rmb-num').text.strip
      images = page.css('ul.tb-thumb img')
      item.urls = images.map{ |img| img.attr('src')[0..-11] }
      item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    

    elsif /tmall\.com/.match url
      item.title = page.css('h3[data-spm]').text.strip
      item.price = page.css('.J_originalPrice').text.strip
      item.mprice = page.css('span.tm-price').text.strip
      images = page.css('li.tb-s60 img')
      item.urls = images.map{ |img| img.attr('src')[0..-14] }
      item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    
    # No more yet
    else
    end

    item
  end

end
