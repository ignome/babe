#coding: utf-8

class ItemsController < ApplicationController

  before_action :find, only: [:show, :like, :unlike]
  before_action :authenticate_user!, only: [:fetch, :like, :unlike, :new, :create, :edit]

  def new
    #@item = Item.new
    render 'new', layout: false
  end

  def show
    Item.increment_counter("views_count", @item.id) # if current_user && current_user.id != item.user_id
    # Guess what's the user liked?
    @items = @item.user.items.limit(15)
    @comments = @item.comments.includes(:user)
    #宝贝{宝贝标题}由宝贝丁{用户}分享，图片精美，价格为{宝贝价格}
    set_seo_meta(@item.title,'', "#{@item.title}#{@item.user.name}分享,最低折扣价格#{@item.mprice}")
  end

  # For Ajax loading more items
  def more
    @items = Item.pins.fields_in_list.order('id desc').paginate(per_page: 20, page: params[:page])
    render partial: 'item', collection: @items
  end

  def fetch
    
    url = params[:url].to_s.strip
    @item  = Item.parse(url)

    if nil == @item
      render json: [-1, 'invalid url']
    else
      if @item.id.to_i > 0
        # make the user as fans of it, If the item already exists
        FansOfItem.where(user_id: current_user.id, item_id: @item.id).first_or_create()
        # Change the url to show details
        render json: {id: @item.id, url: "#{item_path(@item.id)}", price: @item.mprice || @item.price, title: "#{@item.title}", cover: "#{@item.cover.default.url}"}.to_json
      else
        render template: 'items/edit.html.erb', object: @item, layout: false, status: 201
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


  def like
    FansOfItem.where(user_id: current_user.id, item_id: params[:id]).first_or_create()

    @item.likes_count += 1
    render text: @item.likes_count
  end

  def unlike
    FansOfItem.destroy_all(user_id: current_user.id, item_id: params[:id])
    @item.likes_count -= 1
    render text: @item.likes_count
  end

  protected

  def item_params
    params.require(:item).permit(:title, :url, :body, :price, :mprice, :selected, :comment, :urls => [])
  end

  def find
    @item = Item.find(params[:id])
  end
end
