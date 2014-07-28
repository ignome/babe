class Cpanel::TagsController < Cpanel::ApplicationController

  before_action :find, only:[:edit,:update,:destroy]

  def index
    @tags = Tag.all.includes([:category]).paginate(per_page: 20, page: params[:page])
  end

  def edit
  end

  def new
    @tag = Tag.new
  end

  def destroy
    @tag.destroy if @tag
    
  end

  def update
    if @tag.update_attributes(tag_params)
      redirect_to cpanel_tags_path, notice: 'update a tag success'
    else
      render 'edit'
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to cpanel_tags_path, notice: 'new tag success'
    else
      render 'new'
    end
  end

  protected
  def find
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :available, :searchable,:recommend, :category_id)
  end
end
