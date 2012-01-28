require 'graph_data_system'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include GraphDataSystem

  # Be sure to include AuthenticationSystem in Application Controller instead
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :require_user
  # before_filter :check_permissions

  helper_method :current_user, 
    :current_project, 
    :plays_current_user_role?,
    :current_user_is_admin_or?,
    :default_title

  rescue_from ActiveScaffold::RecordNotAllowed, :with => :permissions_error
  rescue_from ActiveScaffold::ActionNotAllowed, :with => :permissions_error

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.url
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_project
    id = params[:controller] == "projects" ?  params[:id] : params[:project_id]
    @current_project ||= (id && Project.find(id.to_i))
  end

  def current_role
    current_user.duties.with_project(current_project).first.role
  end

  def plays_current_user_role? *role_list
    role_list.map(&:to_s).include?(current_role.permalink) rescue false
  end

  def current_user_is_admin_or? *role_list
    current_user.admin? || plays_current_user_role?(*role_list)
  end


  def default_title
    @default_title ||= case action_name
    when "index"
      "Listing #{controller_name.humanize}"
    else
      "#{action_name.humanize} #{controller_name.singularize.humanize}"
    end
  end

  def there_are_no_admins
    User.find_by_admin(true) ? false : true
  end

  def permissions_error e
    if [ActiveScaffold::ActionNotAllowed, ActiveScaffold::RecordNotAllowed].include? e.class
      flash[:error] = "Action not allowed."
    else
      flash[:error] = "Internal server error."
    end

    redirect_to message_path
  end

  def render_message message
    @message = message
    render :template => 'message/index'
  end

  def do_new_with_project
    @record = active_scaffold_config.model.new :project => current_project
    apply_constraints_to_record(@record)
    params[:eid] = @old_eid if @remove_eid
    @record
  end
end
