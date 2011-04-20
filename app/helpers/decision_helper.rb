module DecisionHelper
  def window_datetime dt
    return dt.strftime('%I:%M%p %Z, %a %m/%d, %Y')
    # "11:59pm EST, Tues 4/19, 2011." @todo
  end
end
