#coding: utf-8

class Provider::Jd < Provider::Base

    def parse
        html = self.fetch
        page = Nokogiri::HTML(html, nil, 'UTF-8')
        @item.title = page.css('div#name h1').text.strip
        @item.mprice = page.css('li#summary-price #jd-price').text.sub! /\D+/, ''
        @item.price = page.css('li#summary-market #page_maprice').text.sub! /\D+/, ''

        page.css('div.spec-items ul.lh img').each do |img|
            # Real 350px image
            host = img.attr('src').split('/')[2]
            @item.urls <<  "http://#{host}/n1/#{img.attr('data-url')}"
        end

        # Should get all pictures of description.
        @item.body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
    end

    def self.iid(url)
        URI(url).path.gsub /\D+/,''
    end
end