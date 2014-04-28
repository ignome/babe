class Cpanel::SectionsController < Cpanel::ApplicationController
  
  before_filter :find, except: [:index, :new, :create]

  def index
    @sections = Section.all.order('sort')
  end

  def edit
  end

  def new
    @section = Section.new
  end

  def update
    if @section.update_attributes(section_params)
      redirect_to cpanel_sections_path, notice: "#{@section.name} have been updated successfully"
    else
      render :edit
    end
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to cpanel_sections_path, notice: 'new section success'
    else
      render 'new'
    end
  end

  def destroy
    @section.destroy
    redirect_to cpanel_sections_path, notice: "#{@section.name} Have been removed successfully"
  end

  protected

  def section_params
    params.require(:section).permit(:name, :sort)
  end

  def find
    @section = Section.find(params[:id])
  end
end
