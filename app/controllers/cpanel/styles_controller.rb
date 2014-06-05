require 'will_paginate/array'

class Cpanel::StylesController < Cpanel::ApplicationController
  
  def index
    @styles = Style.all(:include => [:user], order: 'id desc').paginate(per_page: 15, page: params[:page])
  end

  def remove
    #Style.where(['id in (?)', params[:id] ]).destroy
    redirect_to cpanel_styles_path, notice: 'remove style success'
  end

  # do as set recommend
  def recommend
    Style.update_all('recommend=1', ['id in (?)', params[:id] ])
    redirect_to cpanel_styles_path, notice: 'set styles as recommend'
  end

  def cancel
    Style.update_all('recommend=0', ['id in (?)', params[:id]])
    redirect_to cpanel_styles_path, notice: 'cancel styles as recommend'
  end

end
