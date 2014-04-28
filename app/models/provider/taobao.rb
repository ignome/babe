#coding: utf-8

class Provider::Taobao < Provider::Base
  
  def parse(url)
    
    html = fetch(it.url, it.id)
    page = Nokogiri::HTML(html, nil, 'GBK')

    it.title = page.css('h3.tb-item-title').text.strip
    it.price = page.css('em.tb-rmb-num').text.strip

    images = page.css('ul.tb-thumb img')

    images.reverse.map{ |img| img.attr('src')[0..-11] }

    it.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')

    class << it
      def download
        Provider::Taobao.perform_async(self.urls, self.id)
      end
    end
    
    it
  end
end