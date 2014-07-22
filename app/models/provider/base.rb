require 'open-uri'
require 'net/http'

class Provider::Base

  #include Sidekiq::Worker

  def initialize(url)
    @item = Item.new
    @item.url = url
    @item.urls = []
    parse
  end

  def item
    @item
  end

  def self.iid(url)
    iid = /id=(\d+)/.match(url)[1]
  end
  
  def self.parse url
    uri = URI(url)
    host = uri.hostname.split('.')[1].downcase
    
    klass = "Provider::#{host.singularize.classify}".constantize
    iid = klass.iid url
    item = Item.where(['provider=? and iid=?', host, iid]).first
    if @item.nil?
      Rails.logger.info "Fetch #{url}"
      instan = klass.new(url)
      item = instan.item
    end
    item
  end
  
  def fetch
    # Should read from config
    uri = URI('http://localhost:8088/')
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('url' => @item.url)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.read_timeout = 10 * 60 * 60
      http.request(req)
    end
    res.body
  end
end