class Cpanel::CatalogsController < Cpanel::ApplicationController
  before_filter :find, only: [:edit, :destroy, :update]
  
  def index
    @catalogs = Catalog.roots.order('sort asc')
  end

  def new
    @catalog = Catalog.new
  end

  def edit
  end

  def update
    if @catalog.update_attributes(catalog_params)
      redirect_to cpanel_catalogs_path, notice: "#{@catalog.name} have been updated successfully"
    else
      render :edit
    end
  end

  def create
    @catalog = Catalog.new(catalog_params)

    if @catalog.save
      redirect_to cpanel_catalogs_path, notice: 'new catalog success'
    else
      render 'new'
    end
  end

  def destroy
    @catalog.destroy
    redirect_to cpanel_catalogs_path, notice: "#{@catalog.name} Have been removed successfully"
  end

  protected

  def catalog_params
    params.require(:catalog).permit(:name, :parent_id, :slug, :sort)
  end

  def find
    @catalog = Catalog.find(params[:id])
  end
end
