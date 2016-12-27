require 'date_util'
require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :details, class_name: 'Detail'
  has_many :summaries, class_name: 'Summary'

  validates :name, :presence => true
  validates :status, :presence => true
  validates :joined_date, :presence => true
  validates :is_admin, :presence => true
  validates :login_name, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validate :password_must_be_present

  attr_accessor :password_confirmation
  attr_reader :password

  include Util::DateUtil


  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  def User.authenticate(login_name, password)
    if user = find_by_login_name(login_name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end


  # return the start and end working day of current user
  def start_and_end_working_day_of_the_year
    #wxhTodo: 这个结束时间应该抽出去,这样可以方便地看历史某天的请假统计状况
    if new_hires_of_the_year?
      return {"start_working_day"=>joined_date, "end_working_day"=>Date.today}
      #return {"start_working_day"=>joined_date, "end_working_day"=> Date.new(2016, 12, 14)}
    else
      return {"start_working_day"=>AnnualStatistic::first_closing_day_of_the_annual_statistic(), "end_working_day"=>Date.today}
      #return {"start_working_day"=>AnnualStatistic::first_closing_day_of_the_annual_statistic(), "end_working_day"=> Date.new(2016, 12, 14)}
    end
  end

  def new_hires_of_the_year?
    return AnnualStatistic::first_closing_day_of_the_annual_statistic() <= joined_date
  end

  def old_staff_at_least_5_years?
    return Date.today > Date.new(joined_date.year+5, joined_date.month, joined_date.day)
  end

private

  def password_must_be_present
    errors.add(:password, "没有密码") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end



