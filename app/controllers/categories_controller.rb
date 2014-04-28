class CategoriesController < ApplicationController

  before_action :find

  def index
    # TODO should cache all IDs of 1-2 level node 
    @roots  = Category.roots

    if params[:third]
      @current_selected = Category.find_by(slug: params[:third])
      ids = [@current_selected.id]
    elsif params[:second]
      @current_selected = Category.find_by(slug: params[:second])
      ids = Category.where(parent: @current_selected.id).select('id').map{|x| x.id}
    else
      ids = Category.where(parent: @category.id).select('id').map(){|x| x.id}
      ids = Category.where(["parent in (?)", ids]).select('id').map(){|x| x.id}
      @current_selected = @category
    end

    @items = Item.where(["category_id in (?)", ids]).order('id desc').paginate(per_page: 20, page: params[:page])
  end

  protected

  def find
    @category = Category.find_by(slug: params[:first])
  end
end
