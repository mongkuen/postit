module ApplicationHelper
  def fix_url(str)
    str.starts_with?("http://") ? str : "http://#{str}"
  end

  def display_datetime(time)
    time.strftime("%m/%d/%Y %l:%M%P %Z") #03/14/2013 9:09pm
  end
end
