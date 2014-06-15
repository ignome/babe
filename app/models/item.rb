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
    self.urls.each_with_index do |url, index|
      Rails.logger.info '*' * 80
      Rails.logger.info url
      begin
        cover = self.covers.new
        cover.file.download! url
      rescue Exception => e
        
        Rails.logger.info e.message
        Rails.logger.info url
        next
      end
      cover.user_id = self.user_id
      cover.save
      # Change the cover too!
      self.cover = cover.file.url if 0 == index
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
    item.urls = []

    if /jd\.com/.match url
      item.title = page.css('div#name h1').text.strip
      item.mprice = page.css('li#summary-price #jd-price').text.sub! /\D+/, ''
      item.price = page.css('li#summary-market #page_maprice').text.sub! /\D+/, ''
      page.css('div.spec-items ul.lh img').each do |img|
        # Real 350px image
        host = img.attr('src').split('/')[2]
        item.urls <<  "http://#{host}/n1/#{img.attr('data-url')}"
      end
      
      # Should get all pictures of description.
      item.body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
    
    
    elsif /taobao\.com/.match url
      # Fuck the long long url, cover to htt://taobao.com/item.html?id=id
      if item.url.length > 128
        id = item.url.match(/(id=\d+)/)[0]
        item.url = item.url.split('?')[0] << '?' << id
      end
      item.title = page.css('#J_Title h3').text.strip
      item.price = page.css('li#J_StrPriceModBox .tb-rmb-num').text.strip.to_f
      item.mprice = page.css('li#J_PromoPrice .tb-rmb-num').text.strip.to_f
      page.css('ul.tb-thumb img').each do |img|
        src = img.attr('data-src').split('.')
        # remove jpg_50x50
        ext = src.delete_at(-2)
        # sometimes xx.png_WWxHH.jpg will 404
        src[-1] = ext.split('_')[0]
        item.urls << src.join('.')
      end
      item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    

    elsif /tmall\.com/.match url
      item.title = page.css('h3[data-spm]').text.strip
      item.price = page.css('li#J_StrPriceModBox .tm-price').text.strip.to_f
      item.mprice = page.css('li#J_PromoPrice .tm-price').text.strip.to_f
      page.css('li.tb-s60 img').each do |img|
        src = img.attr('src').split('.')
        ext = src.delete_at(-2)
        # sometimes xx.png_WWxHH.jpg will 404
        src[-1] = ext.split('_')[0]
        item.urls << src.join('.')
      end
      item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    
    # No more yet
    else
    end

    item
  end

end
