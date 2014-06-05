class Cpanel::PositionsController < Cpanel::ApplicationController

  before_action :find, only: [:edit, :update, :destroy]

  def index
    @positions = Position.recently.paginate(per_page: 16, page: params[:page])
  end

  def new
    @position = Position.new
  end

  def edit
  end

  def update
    if @position.update_attributes(position_params)
      redirect_to cpanel_positions_path, notice: 'update a position success'
    else
      render 'edit'
    end
  end

  def create
    @position = Position.new(position_params)
    if @position.save
      redirect_to cpanel_positions_path, notice: 'new position success'
    else
      render 'new'
    end
  end

  def destroy
    @position.destroy
    redirect_to cpanel_positions_path, notice: 'remove a position success'
  end

  protected

  def position_params
    params.require(:position).permit(:title, :slug, :width, :height, :description)
  end

  def find
    @position = Position.find(params[:id])
  end
end
