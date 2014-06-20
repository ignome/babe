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

  def cover
    file = File.open('cover.txt', 'w')
    Item.all.each do |item|
      begin
        if !item.cover.file.exists?
          photo = item.photos.first
          if photo.file.file.exists?
            item.cover = File.new( photo.file.path )
            item.save
          else
            file.puts "#{item.id} with #{photo.id} cover not set"
          end          
        end
      rescue Exception=> e
        file.puts e.message
        file.puts item.id
      end
    end
    file.close
    render text: 'finish'
  end

  def moveto
    category = params['catalog'].split(',')[-1]
    Item.where(id: params[:id]).update_all(catalog: params[:catalog], category_id: category)
    redirect_to cpanel_items_path, notice: 'Moved class'
  end

  def remove
    Item.destroy_all(id: params[:id])
    page = params[:page].to_i > 0 ? params[:page] : 1
    redirect_to cpanel_items_path(page: page), notice: 'remove success'
  end

end
