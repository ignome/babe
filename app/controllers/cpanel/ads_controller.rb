class Cpanel::AdsController < Cpanel::ApplicationController
  
  before_action :find, only: [:edit, :update, :destroy]
  #before_action :convert_datetime_to_int,  only:[:update, :create]

  def index
    @ads = Ad.recent.includes(:position).paginate(per_page: 16, page: params[:page])
  end

  def edit
  end

  def update
    @ad.cover = params[:ad][:cover]
    if @ad.update_attributes ad_params
      redirect_to cpanel_ads_path, notice: 'update an advertisement success'
    else
      render 'edit'
    end
  end

  def new
    @ad = Ad.new
  end

  def create
    ps = Position.find(params[:ad][:position_id])
    @ad = ps.ads.build(ad_params)
    @ad.cover = params[:ad][:cover]
    @ad.user_id = current_user.id

    if @ad.save
      redirect_to cpanel_ads_path, notice: 'new an advertisement success'
    else
      render 'new'
    end
  end

  def destroy
    @ad.destroy
    redirect_to cpanel_ads_path, notice: 'remove an advertisement'
  end

  protected

  def ad_params
    params.require(:ad).permit(:title, :url, :start_on, :expires_on, :description, :position_id)
  end

  def find
    @ad = Ad.find(params[:id])
    render_404 if @ad.nil?
  end

  def convert_datetime_to_int
   DateTime.new(params['start_on(1i)'],
                                     params['start_on(2i)'],
                                     params['start_on(3i)'],
                                     params['start_on(4i)'],
                                     params['start_on(5i)']).to_time.to_i

    DateTime.new(params['expires_on(1i)'],
                                 params['expires_on(2i)'],
                                 params['expires_on(3i)'],
                                 params['expires_on(4i)'],
                                 params['expires_on(5i)']).to_time.to_i
  end
end
