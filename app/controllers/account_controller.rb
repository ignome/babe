class AccountController < Devise::RegistrationsController
  
  before_action :authenticate_user!
  #before_filter :drafteed_by_user!, only: [:create]

  def new
    build_resource({})
    render 'account/signup', layout: 'user'
  end

  def edit
    @user = current_user
    #set_seo_meta('修改个人信息')
  end
  
  def update
    @user = current_user

    if @user.update_attributes( params[:user].permit('name') )
      redirect_to edit_user_registration_path, notice: 'update success'
    else
      render :action => "edit"
    end
  end

  def create
    build_resource(sign_up_params)
    resource.login = params[resource_name][:login]
    resource.email = params[resource_name][:email]
    resource.name  = params[resource_name][:name]
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      #respond_with resource
      render 'account/signup', layout: 'user'
    end
  end

end
