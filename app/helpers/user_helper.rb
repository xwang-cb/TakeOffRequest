module UserHelper

  def get_leave_type_name(val)
    if val == Summary.types[:annual]
      return '年假'
    else
      return '病假'
    end
  end

  def medical_leave?(val)
    return val == Summary.types[:medical]
  end

  def super_admin?(user)
    return user.name == 'Admin'
  end

  def get_status_name(val)
    if val == '1'
      return '在职'
    else
      return '离职'
    end
  end

  def admin?(user)
    return (user.is_admin == 'Yes')
  end

  def admin?
    if login?
      return User.find(session[:user_id]).is_admin == 'Yes'
    end

    return false
  end

  def login?
    return session[:user_id]
  end

end