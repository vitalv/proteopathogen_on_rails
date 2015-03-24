class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :current_user
  
  #this catches ActiveRecord::RecordNotFound exceptions, try spectrum_identifications/999999/results, and then comment out and try again
  #But it does not catch an made up route, like this spectrum_identifications/4/resultaishions
  #to catch those there is get "*path" => 'errors#routing' in routes.rb and the errors_controller
  #UNCOMMENT IN PRODUCTION, IN DEV , I DO WANT TO SEE THE ERRORS/EXCEPTIONS
  
  #rescue_from Exception, :with => :error_render_method
  #def error_render_method
  #  respond_to do |type|
  #    #type.html { render :template => "errors/error_404", status: 404 }
  #    type.html { render file: "#{Rails.root}/public/404.html", status: 404 }
  #    type.all  { render :nothing => true, :status => 404 }
  #  end
  #  true
  #end


  private

  def current_user
    
    #the require login is used in the Users controller to let only logged_in users (defined here) do stuff
    #but I want not just any logged_in user, only "Admin" user, to be able to create new users!
    
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
    #@current_user ||= User.find(session[:user_id]) if session[:user_id] == User.find_by_email("vital@ucm.es").id
    #No, this does not do as expected
    
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "you must be logged in to access this section"
      redirect_to log_in_path
    end
  end
  
  def logged_in?
    !!current_user 
    #About !!
    #The internal logic it uses to decide this value is by checking to see if the current_user variable is set.
    #If it is set, it will evaluate to true in a boolean context. 
    #If not, it will evaluate as false. The double negation forces the return value to be a boolean
  end
  
end
