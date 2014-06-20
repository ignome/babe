#coding: utf-8
require 'open-uri'
require 'net/http'

class ItemsController < ApplicationController

  before_action :find, only: [:show, :like, :unlike]
  before_action :authenticate_user!, only: [:fetch, :like, :unlike, :new, :create, :edit]

  def new
    @item = Item.new
  end

  def show
    Item.increment_counter("views_count", @item.id) # if current_user && current_user.id != item.user_id
    # Guess what's the user liked?
    @items = @item.user.items.limit(15)
    @comments = @item.comments.includes(:user)
  end

  # For Ajax loading more items
  def more
    @items = Item.order('id desc').paginate(per_page: 20, page: params[:page])
    render partial: 'item', collection: @items
  end

  def fetch
    
    url = params[:url].to_s.strip

    if /(jd|tmall|taobao|)\.com/.match url
      @item  = Item.parse(url)
      @item.user_id = current_user.id
      
      if params[:save]
        @item.save
        render json: [0, @item], only: [:title, :url, :price, :cover]
      else
        render template: 'items/edit.html.erb', object: @item, layout: false, status: 201
      end
    else
      render json: [-1, 'Invalid URL provided']
    end
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
