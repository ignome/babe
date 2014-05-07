#coding: utf-8

class ItemsController < ApplicationController

  before_action :find, only: [:show, :like, :unlike]
  before_action :authenticate_user!, only: [:like, :unlike, :new, :create, :edit]

  def new
    @item = Item.new
  end

  def show
    # Recommend by : same color and same category
  end

  def create_test
    #item = item_params
    response = Net::HTTP.post_form(URI('http://localhost:8088'), {'url' => params[:url]})

    page = Nokogiri::HTML(response.body, nil, 'GBK')
    # Invalid URL, if can not found the target element.
    p=2
    if p == 1
      title = page.css('div#name h1').text.strip
      price = page.css('strong#jd-price').text.strip[1..-1]
      body = page.css('div.detail-content img').map{|img| img.attr('data-lazyload')}.join(';')
    elsif p==2
      title = page.css('h3[data-spm]').text.strip
      price = page.css('.J_originalPrice').text.strip
      
      images = page.css('li.tb-s60 img')
      urls = images.reverse.map{ |img| img.attr('src')[0..-14] }
      body = page.css('div#description img').map{ |img| img.attr('src') }.join(';')
    else
    end
      
    render text: response.body
  end

  def create
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
    params.require(:item).permit(:url)
  end

  def find
    @item = Item.find(params[:id])
  end
end
