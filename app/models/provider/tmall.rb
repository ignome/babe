#coding: utf-8

class Provider::Tmall < Provider::Base

  def parse
    html = self.fetch
    page = Nokogiri::HTML(html, nil, 'UTF-8')
    
    @item.title = page.css('div.tb-detail-hd h1').text.strip
    @item.price = page.css('#J_StrPriceModBox .tm-price').text.strip.to_f
    @item.mprice = page.css('#J_PromoPrice .tm-price').text.strip.to_f
    page.css('ul#J_UlThumb img').each do |img|
        src = img.attr('src').split('.')
        ext = src.delete_at(-2)
        # sometimes xx.png_WWxHH.jpg will 404
        src[-1] = ext.split('_')[0]
        @item.urls << src.join('.')
    end

    # Details got by regular
    self.body html

    @item.iid = Provider::Tmall.iid(@item.url)
    @item.provider = 'taobao'
    slugs = @item.url.split('?')
    id = /id=(\d+)/.match(slugs[1])
    if id
      @item.url = slugs[0] << '?id=' << id[1]
    end
  end

  def body html
    #descUrl":"http://dsc.taobaocdn.com/i1/380/510/38251046430/TB1WK4RFVXXXXbCXpXX8qtpFXXX.desc%7Cvar%5Edesc%3Bsign%5E6c7c3fae3bd71af2dd45baa201077160%3Blang%5Egbk%3Bt%5E1405829236","fetchDcUrl":
    m = /"descUrl":"([^"]+)"/.match(html)
    if m
        text = open(m[1]).read
        @item.body = text.scan(/src="([^"]+)"/).join(';')
    end
  end
end