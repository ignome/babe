require 'open-uri'
require 'net/http'

class Provider::Base

  include Sidekiq::Worker

  def perform(urls, id)
    it = Item.find(id)
    if it
        urls.each do |url|
            cover = it.covers.new
            cover.file.download! url
            cover.user_id = it.user_id
            cover.save
            # Change the cover too!
            it.cover = cover.file.default.url
        end
        it.save
    end
  end
  
  # Automatic retry 5 times if return is emtpy!
  def self.fetch(url, id=0)
    response = Net::HTTP.post_form(URI('http://127.0.0.1:8088'), {'url' => url, 'id' => id})
    response.body
  end
  
end