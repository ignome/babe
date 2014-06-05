class Cpanel::PagesController < Cpanel::ApplicationController
  before_action :find, only: [:edit, :update, :destroy]

  def index
    @posts = Page.paginate(per_page: 16, page: params[:page])
  end

  def new
    @post = Page.new
  end

  def edit
  end

  def update
    if @post.update_attributes(page_params)
      redirect_to cpanel_pages_path, notice: 'update a post success'
    else
      render 'edit'
    end
  end

  def create
    @post = Page.new(page_params)
    if @post.save
      redirect_to cpanel_pages_path, notice: 'new post success'
    else
      render 'new'
    end
  end

  def destroy
    @post.destroy
    redirect_to cpanel_pages_path, notice: 'remove a post success'
  end

  protected

  def page_params
    params.require(:page).permit(:title, :catalog_id, :keywords, :description,  :body)
  end

  def find
    @post = Page.find(params[:id])
  end
end
