admin_label = ->(key) { I18n.t("rails_admin_models.#{key}") }

RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_user)
  ## == Devise ==
  config.authenticate_with do
    # authenticate_admin_user!
    # warden.authenticate! scope: :user
    redirect_to main_app.root_path, alert: '无权限' unless current_user.present? && current_user.has_role?('super_admin')
  end

  ## == Cancan ==
  # config.authorize_with :cancan
  # config.authorize_with :cancancan
  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  #config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  #
  config.main_app_name = ["Aprove AI", "Admin"]
  config.included_models = ["Resource", 'Role', 'User', 'Organization', 'Company', 'Category', 'ProductCategory', 'CostCategory', 'Factory', 'Order']

  config.model 'User' do
    label { admin_label.call('user') }
    label_plural { admin_label.call('users') }
    field :login do
      label { admin_label.call('fields.account') }
    end
    field :email do
      label { admin_label.call('fields.email') }
    end
    field :password do
      label { admin_label.call('fields.password') }
      help false
    end
    field :title do
      label { admin_label.call('fields.title') }
    end
    field :name do
      label { admin_label.call('fields.name') }
    end
    field :organization do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label { admin_label.call('fields.organization') }
    end
    field :roles do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label { admin_label.call('fields.roles') }
    end
    field :agent do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label { admin_label.call('fields.partner') }
    end
  end

  config.model 'Role' do
    object_label_method :localized_name
    label { admin_label.call('role') }
    label_plural { admin_label.call('roles') }
    field :name do
      label { admin_label.call('fields.role_name') }
    end
    field :desc  do
      label { admin_label.call('fields.description') }
    end
    field :resources do
      associated_collection_cache_all true
      label { admin_label.call('fields.permissions') }
    end
  end

  config.model 'Resource' do
    label { admin_label.call('resource') }
    label_plural { admin_label.call('resources') }
    field :name do
      label { admin_label.call('fields.description') }
    end
    field :action do
      label { admin_label.call('fields.action') }
    end
    field :target do
      label { admin_label.call('fields.module') }
    end
  end

  config.model 'Organization' do
    label { admin_label.call('organization') }
    label_plural { admin_label.call('organizations') }
    field :name do
      label { admin_label.call('fields.organization_name') }
    end
  end

  config.model 'Company' do
    label { admin_label.call('customer') }
    label_plural { admin_label.call('customers') }
    field :name do
      label { admin_label.call('fields.company_name') }
    end
    field :desc do
      label { admin_label.call('fields.description') }
    end
  end

  config.model 'Category' do
    label { admin_label.call('project_category') }
    label_plural { admin_label.call('project_categories') }
    field :name do
      label { admin_label.call('fields.category_name') }
    end
  end

  config.model 'ProductCategory' do
    label { admin_label.call('product_category') }
    label_plural { admin_label.call('product_categories') }
    field :name do
      label { admin_label.call('fields.category_name') }
    end
    field :desc do
      label { admin_label.call('fields.details') }
    end
  end

  config.model 'CostCategory' do
    label { admin_label.call('expense_category') }
    label_plural { admin_label.call('expense_categories') }
    field :name do
      label { admin_label.call('fields.expense_category') }
    end
    field :desc do
      label { admin_label.call('fields.details') }
    end
  end

  config.model 'Order' do
    label { admin_label.call('order') }
    label_plural { admin_label.call('orders') }
    field :no do
      label { admin_label.call('fields.number') }
    end
    field :project do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label { admin_label.call('fields.project') }
    end
    field :user do
      associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
      label { admin_label.call('fields.created_by') }
    end
    field :total_price do
      label { admin_label.call('fields.total_amount') }
    end

  end

  config.model 'Factory' do
    label { admin_label.call('supplier') }
    label_plural { admin_label.call('suppliers') }
    field :name do
      label { admin_label.call('fields.supplier_name') }
    end
    field :address do
      label { admin_label.call('fields.address') }
    end
    field :desc do
      label { admin_label.call('fields.details') }
    end
  end




  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit do
      except [Order]
    end
    delete
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
