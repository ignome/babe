class CategoriesController < ApplicationController

  before_action :find

  def index
    # TODO should cache all IDs of 1-2 level node 
    @roots  = Category.roots

    @current_selected = @category
    ids = ["#{@category.id}"]

    if params[:second]
      @current_selected = Category.find_by(slug: params[:second])
      ids << "#{@current_selected.id}"
    end
    
    keywords = "#{@current_selected.child.map{|child| child.name}.join(',')}"

    if params[:third]
      @current_selected = Category.find_by(slug: params[:third])
      ids << "#{@current_selected.id}"
    end
    
    if ids.length < 3 
      ids << "%"
    end

    title = "#{@current_selected.name}-宝贝丁儿童#{@current_selected.name}_2014春夏季新款时尚品牌儿童#{@current_selected.name}"
    description = "欢迎访问宝贝丁儿童#{@current_selected.name}频道，这里有淘宝网购物达人妈妈精心挑选的最热2014新款时尚品牌儿童#{@current_selected.name}，发现当季最潮品牌儿童T恤和最佳搭配心得。"
    @items = Item.where(["catalog like ?", ids.join(',')]).order('id desc').paginate(per_page: 50, page: params[:page])

    set_seo_meta(title, keywords, description)
  end

  protected

  def find
    @category = Category.find_by(slug: params[:first])

    render_404 unless @category
  end
end
