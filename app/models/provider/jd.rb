#coding: utf-8

class Provider::JD < Provider::Base

  def self.parse(url)

    html = fetch(url)
    # File.open("#{Rails.root}/#{it.id}.html").read
    page = Nokogiri::HTML(html, nil, 'GBK')

    it = Item.new
    it.title = page.css('div#name h1').text.strip
    it.price = page.css('strong#jd-price').text.strip[1..-1]

    images = page.css('div.spec-items ul.lh img')
    # Real 350px image
    host = images[0].attr('src').split('/')[2]
    # Reverse to keep the original order!
    it.urls = images.reverse.map{|img| "http://#{host}/n1/#{img.attr('data-url')}"}
    # Should get all pictures of description.
    it.body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
    # Delay the download after the item saved
    class << it
        def download
            Provider::JD.perform_async(self.urls, self.id)
        end
    end
    it
  end
end