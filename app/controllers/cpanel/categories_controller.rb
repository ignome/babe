class Cpanel::CategoriesController < Cpanel::ApplicationController

  before_filter :find, only: [:edit, :destroy, :update]
  
  def index
    @categories = Category.all.order('sort asc')
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to cpanel_categories_path, notice: "#{@category.name} have been updated successfully"
    else
      render :edit
    end
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to cpanel_categories_path, notice: 'new category success'
    else
      render 'new'
    end
  end

  def destroy
    @category.destroy
    redirect_to cpanel_categories_path, notice: "#{@category.name} Have been removed successfully"
  end

  protected

  def category_params
    params.require(:category).permit(:name, :parent, :slug, :sort)
  end

  def find
    @category = Category.find(params[:id])
  end
end
