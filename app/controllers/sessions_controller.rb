class SessionsController < ApplicationController
  skip_before_filter :authorize
  layout "login"

  def new

  end

  def create
    if user = User.authenticate(params[:login_name], params[:password])
      session[:user_id] = user.id

      if admin?
        redirect_to summaries_path
      else
        redirect_to summaries_user_path(:user_id => session[:user_id])
      end
    else
      redirect_to login_url, :alert => '你输入了错误的用户名/密码'
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to login_path
  end
end
