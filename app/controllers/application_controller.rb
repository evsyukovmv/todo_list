class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      flash[:error] = 'Not allowed'
      redirect_to access_url
    else
      flash[:error] = 'Please, sign in'
      redirect_to root_path
    end
  end
end
