module ApplicationHelper
  def ui_icon(name, options = {})
    classes = ['app-icon', options.delete(:class)].compact.join(' ')
    lucide_icon(name.to_s, **{ class: classes, 'aria-hidden': 'true' }.merge(options.symbolize_keys))
  end

  def localized_options(options, scope)
    options.map do |value, fallback|
      [I18n.t("#{scope}.#{value}", default: fallback), value]
    end
  end


  def switch_locale_path(locale)
    query = request.query_parameters.merge(locale: locale)
    "#{request.path}?#{query.to_query}"
  end

  def simple_time datetime
    datetime.strftime('%Y-%m-%d')if datetime.present?
  end

  def simple_time_mini datetime
    datetime.strftime('%Y-%m-%d %H:%M:%S')if datetime.present?
  end


  def get_title params
    fallback = title_config.dig(params[:controller].to_sym, params[:action].to_sym).to_s
    I18n.t("page_titles.#{params[:controller]}.#{params[:action]}", default: fallback)
  end

  def title_config
    {
        projects: {
            index: '项目列表',
            new: '立项',
            create: '立项',
            show: '详情',
            agent: '代理商',
            report: '项目报备',
            sales: '合同价格体系',
            edit: '项目编辑',
            update: '项目编辑',
            contract_order: '集采订单',
            do_contract_order: '集采订单'
        },
        contracts: {
            index: '战略合同列表',
            new: '添加合同',
            create: '添加合同',
            show: '详情',
            edit: '合同编辑',
            update: '合同编辑'
        },
        audits: {
            index: '审批操作台',
            orders: '样品审批',
            bargains: '特价审批',
            agents: '代理审批',
            invoices: '开票审批',
            projects: '项目审批',
            audits: '我的审批记录'
        },
        manage_orders: {
            index: '订单列表'
        },
        agents: {
            index: '代理商列表',
            new: '代理商申请',
            create: '代理商申请'
        },
        products: {
            index: '产品列表',
            new: '添加产品',
            create: '添加产品',
            edit: '修改产品',
            update: '修改产品',
            contract_sales: '合同价列表'
        },
        costs: {
            index: '费用列表',
            new: '添加费用',
            create: '添加费用',
            edit: '修改费用',
            update: '修改费用'
        },
        notices: {
            index: '消息列表'
        },
        trains: {
            index: '培训资料列表'
        },
        competitors: {
            index: '竞品信息列表'
        },
        invoices: {
            index: '开票列表'
        },
        manage_invoices: {
            index: '开票列表'
        },
        record_reports: {
            index: '今日看板',
            orders: '订单报表',
            users: '人员业绩报表',
            projects: '项目报表',
            invoices: '开票报表',
            cost: '人员费用报表',
            products: '产品报表'
        },
        attachments: {
            index: '文件管理'
        }
    }
  end


  def create_link(object, content, options = {})
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym], options)
    end
  end


  def active_class params, controller, action=nil
    if action.present?
      params[:controller] == controller && params[:action] == action ? 'active' : ''
    else
      params[:controller] == controller ? 'active' : ''
    end
  end


  def redirect_path notice
    case notice.model_type
    when 'project_need_audit'
      projects_audits_path
    when 'project_audited'
      project_path notice.model_id
    when 'project_failed_audit'
      project_path notice.model_id
    when 'sample_order_need_audit'
      orders_audits_path
    when 'sample_order_audited'
      project_path notice.order.project
    when 'sample_order_failed_audit'
      project_path notice.order.project
    when 'bargains_order_need_audit'
      bargains_audits_path
    when 'bargains_order_audited'
      project_path notice.order.project
    when 'bargains_order_failed_audit'
      project_path notice.order.project
    when 'order_deliver'
      manage_orders_path
    when 'order_sign'
      project_path notice.order.project
    when 'agent_need_audit'
      agents_audits_path
    when 'agent_audited'
      agents_path
    when 'agent_failed_audit'
      agents_path
    when 'invoice_need_audit'
      invoices_audits_path
    when 'invoice_failed'
      project_path notice.invoice.project
    when 'invoice_applied'
      project_path notice.invoice.project
    when 'invoice_need_send'
      invoices_audits_path
    when 'invoice_sended'
      project_path notice.invoice.project
    when 'advance_overdue'
      project_path notice.model_id
    when 'settlement_overdue'
      project_path notice.model_id
    when 'bond_overdue'
      project_path notice.model_id
    end
  end

  def show_file_name default_name, file
    file.file_name.size > 10 ? "#{default_name}_#{simple_time file.created_at}" : file.file_name
  end

  def get_color_class project
    if project.payment_percent
      if project.payment_percent >= 0.95
        'label-success'
      elsif project.payment_percent >= 0.75
        'label-info'
      elsif project.payment_percent >= 0.50
        'bg-blue'
      elsif project.payment_percent >= 0.25
        'label-warning'
      else
        'label-danger'
      end
    else

    end
  end

  def format_float number
   # number.present? ?  "#{(number * 100).ceil 2}%" : ''
  end

  def page_numbers params
    params[:page] ||= 1
    page = params[:page].to_i
    (page - 1) * Settings.per_page
  end

  def get_select_columns column
    arr = []
    column.split('.').each_with_index do |s, index|
      if index == 0
        arr << s.singularize
      else
        arr << s
      end
    end
    arr.join '.'
  end

  def format_select_column column
    if column == 'orders.no'
      I18n.t('sections.dynamic_reports.fields.order_number')
    elsif column == 'products.no'
      I18n.t('sections.dynamic_reports.fields.product_code')
    elsif column == 'contracts.no'
      I18n.t('sections.dynamic_reports.fields.contract_number')
    else
      I18n.t(
        "activerecord.attributes.#{get_select_columns(column)}",
        default: column.split('.').last.humanize
      )
    end
  end

  def format_select_value data, column
    value = data.send column.split('.').join('_')
    if value.is_a? Time
      value = simple_time_mini(value)
    elsif column == 'projects.city'
      value = ChinaCity.get(value, prepend_parent: true) if value.present?
    elsif column == 'sales.price'
      value = data.contract_sale_price
    end
    value
  end


end
