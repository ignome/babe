class UsersController < ApplicationController

  before_action :find, only: [:show, :followers, :following, :follow, :unfollow, :items, :likes, :topics]
  before_action :authenticate_user!, only: [:follow, :unfollow]

  def index
    @users = User.all.order('items_count desc')
  end

  def show
    # Last 12 items
    @items = Item.where(user_id: @user.id).order('created_at desc').paginate(per_page: 30, page:  params[:page])
    set_seo_meta(@user.name, "#{@user.name}分享的宝贝")
  end

  def items
    @items = Item.where(user_id: @user.id).paginate(per_page: 12, page: params[:page])
  end

  def likes
    @items = @user.likes.paginate(per_page: 12, page: params[:page])
    set_seo_meta(@user.name, "#{@user.name}喜欢的宝贝")
    render 'items'
  end

  def topics
    @topics = @user.topics.includes(:node).fields_in_list.paginate(per_page: 20, page: params[:page])
  end

  def followers
    @users = @user.followers.paginate(per_page: 32, page: params[:page])
    render 'following'
  end

  def following
    @users = @user.following.paginate(per_page: 32, page: params[:page])
  end

  def follow
    if @user.id != current_user.id
      Followership.where({follower_id: current_user.id, following_id: @user.id}).first_or_create
      render nothing: true, status: 201
    else
      render nothing: true
    end
  end

  def unfollow
    Followership.where({follower_id: current_user.id, following_id: @user.id}).destroy_all
    render nothing: true, status: 201
  end


  protected

  def find
    login = params[:id] || params[:user_id]
    @user = User.find_by(login: login)
    render_404 unless @user
  end
end
