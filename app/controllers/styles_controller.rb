class StylesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit]

  def index
    @styles = Style.all.includes(:photos)
  end

  def show
    @style = Style.find(params[:id])
    @styles = @style.user.styles
  end

  def new
    @style = Style.new
  end

  def create

    @style = current_user.styles.new( style_params )
    if @style.save
      redirect_to style_path(@style.id), notice: 'success'
    else
      render 'new'
    end
  end

  protected

  def style_params
    params.require(:style).permit(:body, :photo => {:id => []}, :item => { :id => []})
  end
end
