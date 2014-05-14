require 'will_paginate/array'

class Cpanel::StylesController < Cpanel::ApplicationController
  def index
    @styles = Style.all(:include => [:user], order: 'id desc').paginate(per_page: 15, page: params[:page])
  end

  def destroy
    Style.find(params[:id]).destroy

    redirect_to cpanel_styles_path, notice: 'remove a style success'
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
