require 'time'

class DetailsController < ApplicationController
  def index
    @details = Detail.all
  end

  def new
    @users = User.all
    @detail = Detail.new
  end

  def create
    @detail = Detail.new(detail_params)

    if @detail.save
      redirect_to details_path
    else
      render 'details/new'
    end
  end

  private
    def detail_params
      params.require(:detail).permit(:user_id, :hours, :type, :start_date)
    end

end
