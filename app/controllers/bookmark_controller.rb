class BookmarkController < ApplicationController

  before_action :authenticate_user!

  def new
    @item = Item.find(params[:id])
    render 'new', layout: false
  end

  def update
  end

  def create
    bm = current_user.bookmarks.build(title:params[:title])
    if bm.save
      json = [0, bm]
    else
      json = [-1, 'error']
    end
    render json: json.to_json
  end

  protected

end