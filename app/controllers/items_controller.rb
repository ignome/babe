#coding: utf-8
require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'hmac-md5'

class ItemsController < ApplicationController

  before_action :find, only: [:show, :like, :unlike]
  #before_action :authenticate_user!, only: [:like, :unlike, :new, :create, :edit]

  def new
    @item = Item.new
  end

  def show
    # Recommend by : same color and same category
    @comments = Comment.where(subject_type: 'Item', subject_id: @item.id)
    Item.increment_counter("views_count", @item.id) # if current_user && current_user.id != item.user_id
    # Guess what's the user liked?
    @items = @item.user.items;

    # Taobao set 
    # secret+"app_key"+app_key+"timestamp"+timestamp+secret, secret
    app_secret = 'e1274b605c5bf851f78871d2668e854a'
    app_key = '21744169'
    key = "#{app_key}"
    # timestamp must be 13 bits
    timestamp = "%d000"% Time.now.to_i.to_s
    sign = HMAC::MD5.new("#{app_secret}app_key#{app_key}timestamp#{timestamp}#{app_secret}").hexdigest
    cookies[:sign] = sign.upcase
    cookies[:timestamp] = timestamp
  end

  def fetch

    if params[:url].blank? or not params[:url].start_with?('http')
      render json: [-1, 'invalid url']
    else
      url = params[:url].strip
      providers = ['taobao.com', 'tmall.com', 'jd.com']
      hostname  = URI(url).host
      supported = hostname.nil? ? 0 : providers.select{ |host| hostname.match(host) }.size

      if 0 == supported
        render json: [-1, 'not supported provider']
      else
        response = Net::HTTP.post_form(URI('http://localhost:8088'), {'url' => url})
        page = Nokogiri::HTML(response.body, nil, 'GBK')
        @item  = current_user.items.new
        @item.url = url;
        Rails.logger.info '-'*80
        Rails.logger.info url
        
        if /jd\.com/.match hostname
          @item.title = page.css('div#name h1').text.strip
          @item.price = page.css('strong#jd-price').text.strip[1..-1]
          @item.mprice = page.css('del#page_maprice').text.sub! /\D+/, ''
          images = page.css('div.spec-items ul.lh img')
          # Real 350px image
          host = images[0].attr('src').split('/')[2]
          # Reverse to keep the original order!
          @item.urls = images.map{|img| "http://#{host}/n1/#{img.attr('data-url')}"}
          # Should get all pictures of description.
          @item.body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
        
        
        elsif /taobao\.com/.match hostname
          # Fuck the long long url, cover to htt://taobao.com/item.html?id=id
          if @item.url.length > 128
            id = @item.url.match(/(id=\d+)/)[0]
            @item.url = @item.url.split('?')[0] << '?' << id
          end
          @item.title = page.css('#J_Title h3').text.strip
          @item.price = page.css('em.tb-rmb-num').text.strip
          images = page.css('ul.tb-thumb img')
          @item.urls = images.map{ |img| img.attr('src')[0..-11] }
          @item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
        

        elsif /tmall\.com/.match hostname
          @item.title = page.css('h3[data-spm]').text.strip
          @item.price = page.css('.J_originalPrice').text.strip
          @item.mprice = page.css('span.tm-price').text.strip
          images = page.css('li.tb-s60 img')
          @item.urls = images.map{ |img| img.attr('src')[0..-14] }
          @item.body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
        
        # No more yet
        else
        end

        Rails.logger.info '*' * 80
        Rails.logger.info 'done'

        if params[:style]
          @item.save

          render json: [0, {id: @item.id, title: @item.title, url: @item.url, price: @item.price, cover: @item.cover} ].to_json
        else
          render template: 'items/edit.html.erb', object: @item, layout: false, status: 201
        end
      end
    end
      
    #render text: 'success'
  end

  def deprecaed_create
    # Receive the URL and perforce_async
    url = params[:url].strip

    # Published by supplied a URL nor a picture
    if url.blank? or not url.start_with?('http')
      redirect_to new_item_path, notice: 'Invalid URL'
    else
      providers = ['taobao.com', 'tmall.com', 'jd.com']
      hostname  = URI(url).host
      supported = hostname.nil? ? false : providers.select{ |host| hostname.match(host) }.size

      if not supported
        #render :text => 'Not supported URL'
        redirect_to new_item_path, notice: 'Not supported URL'
      else
        case hostname.split('.')[1]
        when 'taobao'
          @item = Provider::Taobao.parse(url)
        when 'tmall'
          @item = Provider::Tmall.parse(url)
        when 'jd'
          @item = Provider::JD.parse(url)
        else
          # Send error Message tell your the invaild
        end

        @item.url = url
        @item.user_id = current_user.id

        if @item.save
          
          @item.download()

          if request.xhr?
            render json: {id: @item.id, url: url, cover: @item.cover, title: @item.title, price: @item.price}
          else
            redirect_to item_path(@item.id)
          end
        else
          if request.xhr?
            render json: {errors: @item.errors.full_messages}
          else
            render 'new'
          end
        end
      end
    end
  end

  def create
    @item = current_user.items.new(item_params)
    if @item.save
      unless @item.comment.blank?
        Rails.logger.info '*' * 80        
      end
      redirect_to item_path(@item.id), notice: 'new item success'
    else
      render 'new'
    end
  end

  def upload
  end

  def like
    FansOfItem.where(user_id: current_user.id, item_id: params[:id]).first_or_create()
    # Render the partial instead of status checking
    #render nothing: true , status: 201
    @item.likes_count += 1
    render text: @item.likes_count
    #render partial: 'likes'
  end

  def unlike
    FansOfItem.destroy_all(user_id: current_user.id, item_id: params[:id])
    @item.likes_count -= 1
    #render partial: 'likes'
    render text: @item.likes_count
  end

  protected

  def item_params
    params.require(:item).permit(:title, :url, :body, :price, :mprice, :comment, :urls => [])
  end

  def find
    @item = Item.find(params[:id])
  end
end
