#coding: utf-8

class Provider::Taobao < Provider::Base
  
  def parse
    html = self.fetch
    page = Nokogiri::HTML(html, nil, 'UTF-8')

    @item.title = page.css('#J_Title h3').text.strip
    @item.price = page.css('li#J_StrPriceModBox .tb-rmb-num').text.strip.to_f
    @item.mprice = page.css('li#J_PromoPrice .tb-rmb-num').text.sub! /\D+/, ''
    page.css('ul.tb-thumb img').each do |img|
      src = img.attr('data-src').split('.')
      # remove jpg_50x50
      ext = src.delete_at(-2)
      # sometimes xx.png_WWxHH.jpg will 404
      src[-1] = ext.split('_')[0]
      @item.urls << src.join('.')
    end

    #item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    self.body
  end

  def body(html)
    #"apiItemDesc":"http://dsc.taobaocdn.com/i2/380/800/38580659713/TB1pwBPFVXXXXX8XpXX8qtpFXXX.desc%7Cvar%5Edesc%3Bsign%5E1181b459db5a7d9ec13ab80e964269c2%3Blang%5Egbk%3Bt%5E1404961707",
    m = /"apiItemDesc":"([^"]+)"/.match(html)
    if m
      text = open(m[1]).read
      @item.body = text.scan(/src="([^"]+)"/).join(';')
    end
  end

end