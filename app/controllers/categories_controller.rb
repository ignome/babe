class CategoriesController < ApplicationController

  before_action :find

  def index
    # TODO should cache all IDs of 1-2 level node 
    @roots  = Category.roots

    @current_selected = @category
    ids = "#{@category.id}"

    if params[:second]
      @current_selected = Category.find_by(slug: params[:second])
      ids << ",#{@current_selected.id}"
    end
    if params[:third]
      @current_selected = Category.find_by(slug: params[:third])
      ids << ",#{@current_selected.id}"
    end
    ids << "%"

    @items = Item.where(["catalog like ?", ids]).order('id desc').paginate(per_page: 50, page: params[:page])
  end

  protected

  def find
    @category = Category.find_by(slug: params[:first])

    render_404 unless @category
  end
end
