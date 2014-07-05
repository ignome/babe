require 'nokogiri'
require 'net/http'

class Item < ActiveRecord::Base

  # For keeping the URL to download 
  attr_accessor :urls, :comment

  belongs_to :user, counter_cache: true
  #belongs_to :category

  has_many :fans_of_items
  has_many :fans, :through => :fans_of_items, :source => :user
  has_many :items_of_categories
  has_many :categories, :through => :items_of_categories
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
    have_set_cover = false
    Rails.logger.info '*' * 80
    self.urls.each_with_index do |url, index|
      Rails.logger.info url
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
      if not have_set_cover
        Rails.logger.info "set cover #{cover.file.path}"
        self.cover = File.new(cover.file.path)
        self.save
        have_set_cover = true
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
    uri = URI(url)
    host = uri.hostname.split('.')[1].downcase
    Rails.logger.info host
    
    case host
    when 'jd'
      iid = uri.path.gsub /\D+/,''
    when 'taobao', 'tmall'
      iid = /id=(\d+)/.match(uri.query)[1]
      url = url.split('?')[0] << '?id=' << iid
    else
      iid = 0
    end

    Rails.logger.info "iid=#{iid}"
    if iid.to_i > 0
      item = Item.where(['provider=? and iid=?', host, iid]).first
    
      unless item
        item = Item.new
        item.url = url
        item.urls = []

        # Should read from config
        uri = URI('http://localhost:8088/')
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data('url' => url)
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          ### important for tmall, taobao
          http.read_timeout = 10 * 60 * 60
          http.request(req)
        end

        # all charset are gbk
        html = res.body.force_encoding('GBK')
        # convert into the same encoding of coding here!
        page = Nokogiri::HTML(html, nil, 'UTF-8')

        if 'jd' == host
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
        
        
        elsif 'taobao' == host
          item.title = page.css('#J_Title h3').text.strip
          item.price = page.css('li#J_StrPriceModBox .tb-rmb-num').text.strip.to_f
          item.mprice = page.css('li#J_PromoPrice .tb-rmb-num').text.sub! /\D+/, ''
          page.css('ul.tb-thumb img').each do |img|
            src = img.attr('data-src').split('.')
            # remove jpg_50x50
            ext = src.delete_at(-2)
            # sometimes xx.png_WWxHH.jpg will 404
            src[-1] = ext.split('_')[0]
            item.urls << src.join('.')
          end
          item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
        

        elsif 'tmall'  == host
          item.title = page.css('div.tb-detail-hd h1').text.strip
          item.price = page.css('li#J_StrPriceModBox .tm-price').text.strip.to_f
          item.mprice = page.css('li#J_PromoPrice .tm-price').text.strip.to_f
          page.css('ul#J_UlThumb img').each do |img|
            src = img.attr('src').split('.')
            ext = src.delete_at(-2)
            # sometimes xx.png_WWxHH.jpg will 404
            src[-1] = ext.split('_')[0]
            item.urls << src.join('.')
          end
          item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
        
        # ... more providers comming here!
        
        end
        # match host

      end
      # end fetch from url
    else
      item = nil
    end
    # iid = 0

    item
  end


  def who_liked user
    self.fans.exists?(id: user)
  end

end
