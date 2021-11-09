class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, notice: 'Can not' }
    end
  end
  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end
end
