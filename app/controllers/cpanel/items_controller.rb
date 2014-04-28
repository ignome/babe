require 'will_paginate/array'

class Cpanel::ItemsController < Cpanel::ApplicationController
  def index
    @items = Item.all(:include => [:user, :category], order: 'id desc').paginate(per_page: 15, page: params[:page])
  end

  def destroy
    Item.find(params[:id]).destroy

    redirect_to cpanel_items_path, notice: 'remove an item success'
  end

  def band

  end

  def moveto
    Item.where(id: params[:id]).update_all(category_id: params[:category])
    redirect_to cpanel_items_path, notice: 'Moved class'
  end

  def remove
    Item.destroy_all(id: params[:id])
    redirect_to cpanel_items_path, notice: 'remove success'
  end

end
