module IndexHelper

  def get_leave_type_name(val)
    p val
    if val == Summary.types[:annual]
      return '年假'
    else
      return '病假'
    end
  end

  def medical_leave?(val)
    return val == Summary.types[:medical]
  end

end