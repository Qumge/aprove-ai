class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :get_notices
  skip_before_action :check_authorization_for_action
  layout 'welcome'

  def index
    redirect_to projects_path if user_signed_in?
  end
end
