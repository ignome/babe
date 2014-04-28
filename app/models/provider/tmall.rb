#coding: utf-8

class Provider::Tmall < Provider::Base

  def self.parse(url)

    html = fetch(url)

    page = Nokogiri::HTML(html, nil, 'GBK')

    it = Item.new
    it.title = page.css('h3[data-spm]').text.strip
    it.price = page.css('.J_originalPrice').text.strip
    
    images = page.css('li.tb-s60 img')
    it.urls = images.reverse.map{ |img| img.attr('src')[0..-14] }
    it.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')

    class << it
        def download
            Provider::Tmall.perform_async(self.urls, self.id)
        end
    end

    it
  end
end