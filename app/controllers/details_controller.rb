require 'time'

class DetailsController < ApplicationController
  before_action :set_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_user_info

  def index
    list
    render :action => 'list'
  end

  def list
    if params[:user_id]
      @details = Detail.where(user_id: params[:user_id]).order(:start_time).reverse_order
    else
      @details = Detail.all.order(:start_time).reverse_order
    end
  end

  def new
    @detail = Detail.new
  end

  def create
    @detail = Detail.new(detail_params)

    if @detail.save
      flash[:notice] = '成功保存记录'
      redirect_to :controller => 'details', :action => 'list', :id => @detail, :user_id => @detail.user_id
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @detail.update(detail_params)
      flash[:notice] = '成功更新记录'
      redirect_to :action => 'list', :id => @detail
    else
      render :action => 'edit'
    end
  end

  def destroy
    user_id = Detail.find(params[:id]).user_id

    @detail.destroy
    redirect_to :action => 'list', :user_id => user_id
  end

private

  def detail_params
    params.require(:detail).permit(:user_id, :hours, :type, :start_time)
  end

  def set_detail
    @detail = Detail.find(params[:id])
  end

  def set_user_info
    @users = User.all
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
  end

end
