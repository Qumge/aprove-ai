module DynamicReport
  extend ActiveSupport::Concern

  def dynamic_payment_report
    datas = dynamic_payment_scope.select('sum(payment_logs.amount) as amounts').where(search_conn).where(payment_conn).group(dynamic_group_columns 'payment')
    datas = datas.select(dynamic_select_columns 'payment')
    datas = datas.select(dynamic_default_select_columns) if dynamic_default_select_columns.present?
    datas = datas.order(group_date_column 'payment')
    datas
  end

  def dynamic_deliver_report
    datas = dynamic_deliver_scope.select('sum(deliver_logs.amount) as amounts').where(search_conn).where(deliver_conn).group(dynamic_group_columns 'deliver')
    datas = datas.select(dynamic_select_columns 'deliver')
    datas = datas.select(dynamic_default_select_columns) if dynamic_default_select_columns.present?
    datas
  end

  def dynamic_applied_report
    datas = dynamic_order_scope.select('sum(order_products.discount_total_price) as amounts').where(search_conn).where(applied_conn).group(dynamic_group_columns 'applied')
    datas = datas.select(dynamic_select_columns 'applied')
    datas = datas.select('order_products.*').select(dynamic_default_select_columns) if dynamic_default_select_columns.present?
    datas
  end


  private
  ############################scope####################
  def dynamic_payment_scope
    PaymentLog.left_joins(order: [:factory, { project: [{ owner: :organization }, :category, :company, :agent] }])
  end

  def dynamic_deliver_scope
    DeliverLog.left_joins(order: [:factory, { project: [{ owner: :organization }, :category, :company, :agent] }])
  end

  def dynamic_order_scope
    OrderProduct.left_joins(
      product: [:product_category, :sales],
      order: [:factory, { project: [{ owner: :organization }, :category, :company, :agent] }]
    )
  end

  def dynamic_cost_scope

  end
  #####################scope###########################

  ########################columns##########################
  #params[:groups] = ['users, orders']
  def dynamic_group_columns type
    groups = params[:groups].collect{|group| "#{group}.id" }.join(',')
    if params[:date_group].present?
      groups = "#{groups}#{',' if groups.present? } to_char(#{group_date_column type}, '#{format_group_date params[:date_group]}')"
    end
    groups
  end

  #params[:groups] = ['users, orders']
  def dynamic_default_select_columns
    params[:groups].collect{|group| "#{group}.id as #{group}_id"}.join(',')
  end

  #params[:select_columns] = ['users.id, users.name']
  def dynamic_select_columns type
    selects = params[:select_columns].collect{|column| "#{column} as #{column.gsub '.', '_'}"}.join(',')
    if params[:date_group].present?
      selects = "#{selects}#{',' if selects.present? } to_char(#{group_date_column type}, '#{format_group_date params[:date_group]}') as view_date"
    else
      selects = "#{selects}#{',' if selects.present? }  #{group_date_column type} as view_date"
    end
    selects
  end
  ######################columns############################


  ######################selects############################

  # 通配检索
  def search_conn
    search = ['1=1']
    if params[:project_id].present?
      search << "projects.id = #{params[:project_id]}"
    end
    if params[:company_id].present?
      search << "projects.company_id = #{params[:company_id]}"
    end
    if params[:product_category_id].present?
      search << "product_categories.id = #{params[:product_category_id]}"
    end
    if params[:category_id].present?
      search << "categories.id = #{params[:category_id]}"
    end
    if params[:user_id].present?
      search << "projects.owner_id = #{params[:user_id]}"
    end
    search.join ' and '
  end
  # 下单检索
  def applied_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "orders.applied_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "orders.applied_at <= '#{end_date}'"
    end
    search.join ' and '
  end
  # 发货检索
  def deliver_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "deliver_logs.deliver_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "deliver_logs.deliver_at <= '#{end_date}'"
    end
    search.join ' and '
  end
  # 回款检索
  def payment_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "payment_logs.payment_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "payment_logs.payment_at <= '#{end_date}'"
    end
    search.join ' and '
  end
  ##################selects##############################
  #
  def format_group_date group_date
    if group_date == 'day'
      'YYYY-MM-DD'
    elsif group_date == 'month'
      'YYYY-MM'
    elsif group_date == 'year'
      'YYYY'
    end
  end

  def group_date_column type
    if type == 'payment'
      'payment_logs.payment_at'
    elsif type == 'deliver'
      'deliver_logs.deliver_at'
    elsif type == 'applied'
      'orders.applied_at'
    end
  end

end
