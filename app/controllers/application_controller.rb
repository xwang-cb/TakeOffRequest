class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize


protected

  def authorize
    unless (session[:user_id] && User.find(session[:user_id]))
      redirect_to login_path, notice: "请登录系统以使用功能"
    end
  end

  def admin_authorize
    if !admin?
      redirect_to login_path, notice: "该功能无法使用"
    end
  end

private

  def admin?
    return User.find(session[:user_id]).is_admin == 'Yes'
  end

end
