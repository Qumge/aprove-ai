class ApplicationController < ActionController::Base

  before_action :set_locale, prepend: true
  protect_from_forgery with: :exception
  before_action :get_adminlte_config
  # before_action :set_layout
  before_action :authenticate_user!
  before_action :get_notices
  before_action :check_authorization_for_action



  def get_notices
    @active_notices = current_user.active_notices if current_user.present?
  end

  def check_authorization_for_action
    if params[:controller].present?
      return true if params[:controller].match('sessions') || params[:controller].match('devise') || params[:controller].match('omniauth_callbacks')
    end
    redirect_to root_path, :alert => "无权限" unless can?(params[:action].to_sym, params[:controller].to_sym)
  end


  def authenticate_admin_user!
    if user_signed_in?
      redirect_to '/' unless current_user.role && current_user.role.name == 'super_admin'
    end
  end

  private

  def set_locale
    requested_locale = params[:locale].presence || session[:locale]
    requested_locale = I18n.default_locale.to_s unless I18n.available_locales.map(&:to_s).include?(requested_locale)

    I18n.locale = requested_locale
    session[:locale] = requested_locale if params[:locale].present?
  end

  #set default layout
  def set_layout
    render layout: false if params[:controller] == 'devise/sessions'
  end


  # -Please configure AdminLTE in the AdminLteConfig class and do not change this function
  # -This function is only used as an intermediate function to get the config settings and transfer them
  # to the layout as instance variables
  def get_adminlte_config
    alc = AdminLteConfig.new

    # If this setting is on, none of the settings that you configured are going to be used
    # Please turn this off through the AdminLteConfig class before seeing your changed in effect
    @demo_mode = alc.demo_mode

    @layout = alc.layout

    @top_nav = alc.top_nav

    @sidebar = alc.sidebar

    @collapsed_sidebar_expand_on_hover = alc.collapsed_sidebar_expand_on_hover

    @right_sidebar_slide = alc.right_sidebar_slide

    @right_sidebar_skin = alc.right_sidebar_skin

    @skin = alc.skin

  end

  class AdminLteConfig

    def initialize
      # -This setting runs the demo features to demo the application for you to decide the configuration settings that you
      # want to use in the production environment.
      # -Please configure the application by using the below settings after demoing the application
      # -Please be cautious that the application won't configure the application with your settings
      # if you do not turn off this setting first!!!
      @demo_mode = true

      # The layout setting specifies how the layout is going to be configured
      # Set this to one of the below settings
      # ''       -> this is the default setting
      # 'fixed'  -> this makes the sidebars scrollable
      # 'boxed'  -> this makes the dashboard smaller in boxed view with a stylish background
      @layout = ''

      # If this setting is on, all the sidebars get disabled and the navigation gets moved to the top navigation bar
      # If this setting is enabled, none of the below sidebar settings will be concerned
      # Default value is false
      @top_nav_only = false

      # This setting collapses the sidebar if it is true
      # Default value is false
      @collapsed_sidebar = false

      # This setting will automatically turn on the @collapsed_sidebar setting
      # The sidebar automatically expands if a user hovers on it if this setting is on
      # Default value is false
      @collapsed_sidebar_expand_on_hover = false

      # Slides the main content to the left if the right control sidebar is opened
      # Default value for this setting is false
      @right_sidebar_slide = false

      # This changes the color of the control sidebar to a light skin color
      # Default value for this setting is false
      @right_sidebar_skin_light = false

      # Pick a skin color for AdminLTE from the below list
      # Default skin color is green
      # 'skin-blue',
      # 'skin-black',
      # 'skin-red',
      # 'skin-yellow',
      # 'skin-purple',
      # 'skin-green',
      # 'skin-blue-light',
      # 'skin-black-light',
      # 'skin-red-light',
      # 'skin-yellow-light',
      # 'skin-purple-light',
      # 'skin-green-light'

      @skin = 'skin-purple'
    end

    # reader methods for the class variables
    def demo_mode
      @demo_mode
    end

    def layout
      if @layout == 'fixed'
        'fixed'
      elsif @layout == 'boxed'
        'layout-boxed'
      else
        ''
      end
    end

    def top_nav
      if @top_nav_only
        'layout-top-nav'
      else
        ''
      end
    end

    def sidebar
      if !@top_nav_only && @collapsed_sidebar
        'sidebar-collapse'
      else
        ''
      end
    end

    def collapsed_sidebar_expand_on_hover
      !@top_nav_only && @collapsed_sidebar_expand_on_hover
    end

    def right_sidebar_slide
      !@top_nav_only && @right_sidebar_slide
    end

    def right_sidebar_skin
      if !@top_nav_only && @right_sidebar_skin_light
        'control-sidebar-light'
      else
        'control-sidebar-dark'
      end
    end

    def skin
      @skin
    end

  end

end
