class SessionsController < Devise::SessionsController
  layout 'user'

  def new
    session["user_return_to"] = request.referrer
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    render 'account/signin'
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
