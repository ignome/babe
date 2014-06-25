require 'will_paginate/array'

class Cpanel::ItemsController < Cpanel::ApplicationController

  before_filter :set_return_page

  def index
    @items = Item.all.includes([:user, :category])
    if params[:c] and params[:c].to_i != 0
      @items = @items.where('catalog like ?', "#{params[:c]}%")
    end
    if not params[:q].blank?
      @items = @items.where('title like ?', "%#{params[:q]}%")
    end
    @items = @items.order('id desc').paginate(per_page: 15, page: params[:page])
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to cpanel_items_path(page: params[:page]), notice: 'remove an item success'
  end

  def band
  end

  def cover
    Item.where('iid=0').select('id,user_id,url').each do |item|

      if item.url.nil?
        item.destroy
        Rails.logger.info "#{item.id} deleted"
        next
      end

      uri = URI(item.url)
      host = uri.hostname.split('.')[1].downcase

      case host
      when 'jd'
        item.iid = uri.path.gsub /\D+/,''
      when 'taobao', 'tmall'
        item.iid = /id=(\d+)/.match(uri.query)[1]
        item.url = item.url.split('?')[0] << '?id=' << item.iid.to_s
      else
        iid = 0
      end
      item.save
    end
    render text: 'done'
  end

  def pin
    Item.where('id in (?)', params[:id]).update_all('status=status+1')
    redirect_to cpanel_items_path(page: params[:page] || 1), notice: 'Set all selected items to pin in homepage'
  end


  def moveto
    category = params['catalog'].split(',')[-1]
    Item.where(id: params[:id]).update_all(catalog: params[:catalog], category_id: category)
    redirect_to cpanel_items_path(page: params[:page]), notice: 'All selected items were moved to category'
  end

  def remove
    Item.destroy_all(id: params[:id])
    redirect_to cpanel_items_path(page: params[:page]), notice: 'remove success'
  end

  private

  def reset_photo
    file = File.open('p.txt', 'w')

    Photo.where(subject_type: 'Item').includes(:subject).each do |p|
      
      begin
        # The item was removed
        if p.subject.nil?
          #FileUtils.remove_dir "#{Rails.root}/public/users/#{p.user_id}/ph"
          p.destroy
          file.puts "#{p.subject_id} lost"
        else
          # Copy old file to dest
          if p.file.nil?
            p.delete
            file.puts "#{p.id} not file uploaded"
          else
            old = "#{Rails.root}/public/users/#{p.user_id}/photo/#{p.id}/#{p.file.file.basename}.#{p.file.file.extension}"
            #file.puts old
            if File.exists? old
              FileUtils.mkdir_p File.dirname p.file.file.path
              FileUtils.mv old, p.file.file.path
              file.puts "copy #{old} to #{p.file.file.path}"
            else
              file.puts "#{old} not found"
            end
          end
        end
      rescue Exception => e
        file.puts e.message
        file.puts "#{p.subject_id} #{p.id}"
      end

    end

    render text: 'done'
  end

  def _reset_cover
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

  def set_return_page
    params[:page] = params[:page].to_i > 0 ? params[:page] : 1
  end
end
