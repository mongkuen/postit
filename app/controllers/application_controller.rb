class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :admin?, :creator?

  def deny_access(msg)
    flash[:error] = "#{msg}"
    redirect_to root_path
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    deny_access("You must log in first.") unless logged_in?
  end

  def admin?
    logged_in? && current_user.role == 'admin' ? true : false
  end

  def require_admin
    deny_access("You don't have permission to do that.") unless admin?
  end

  def creator?(obj)
    logged_in? && current_user == (obj.creator) ? true : false
  end

  def restrict_post_edit(obj)
    deny_access("You don't have permission to do that.") unless creator?(obj) || admin?
  end

end
