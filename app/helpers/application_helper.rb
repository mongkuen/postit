module ApplicationHelper
  def fix_url(str)
    str.starts_with?("http://") ? str : "http://#{str}"
  end

  def display_datetime(time)
    if logged_in? && current_user.time_zone
      time = time.in_time_zone(current_user.time_zone)
    end
    time.strftime("%m/%d/%Y %l:%M%P %Z") #03/14/2013 9:09pm
  end

  def upvote_arrow(object)
    if object.votes.where(creator: current_user, vote: true).size == 0
      "<i class='icon-arrow-up'></i>".html_safe
    else
      "<i class='icon-arrow-up icon-white'></i>".html_safe
    end
  end

  def downvote_arrow(object)
    if object.votes.where(creator: current_user, vote: false).size == 0
      "<i class='icon-arrow-down'></i>".html_safe
    else
      "<i class='icon-arrow-down icon-white'></i>".html_safe
    end
  end

end
