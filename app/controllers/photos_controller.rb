class PhotosController < ApplicationController
  
  before_action :authenticate_user!

  def index
    render nothing: true, status: 200
  end

  def create
    result  = {files: []}

    params[:files].each do |file|
      @photo = current_user.photos.new(file: file)
      
      if @photo.save
        #render :json => {'files' => [@photo.to_jq_upload]}.to_json
        result[:files] << @photo.to_jq_upload
      else
        #render :json => [{:error => 'Upload failure'}], :status => 304
        result[:files] << {:error => @photo.errors.full_messages}
      end
    end
    render :json => result.to_json
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    render :json => true
  end

end