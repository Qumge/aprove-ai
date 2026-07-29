module ReportData
  extend ActiveSupport::Concern
  ####################################### begin scope  #######################################
  def order_product_scope
    order_products = OrderProduct.joins({order: {project: [:category, owner: :organization]}}, {product: :product_category})
    order_products = order_products.where('organizations.id in (?)', @organization.subtree_ids) if @organization.present?
    order_products
  end

  def order_scope
    orders = Order.joins({project: [:category, owner: :organization]})
    orders = orders.where('organizations.id in (?)', @organization.subtree_ids) if @organization.present?
    orders
  end

  def cost_scope
    costs = Cost.joins(user: :organization)
    costs = costs.where('organizations.id in (?)', @organization.subtree_ids) if @organization.present?
    costs
  end

  def invoice_scope
    invoices = Invoice.joins(user: :organization)
    invoices = invoices.where('organizations.id in (?)', @organization.subtree_ids) if @organization.present?
    invoices
  end


  ############# end scope


  ####################################### begin search conn #######################################
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

  # 已下单where
  # type： deliver, applied, payment
  def order_type_conn type
    search = ['1=1']
    if type == 'payment'
      if params[:begin_date].present?

      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "payment_logs.#{type}_at >= '#{begin_date}'"
      end
      if params[:end_date].present?
        end_date = params[:end_date].to_date.end_of_day
        search << "payment_logs.#{type}_at <= '#{end_date}'"
      end
    elsif type == 'deliver'
      if params[:begin_date].present?
        begin_date = params[:begin_date].to_date.beginning_of_day
        search << "deliver_logs.#{type}_at >= '#{begin_date}'"
      end
      if params[:end_date].present?
        end_date = params[:end_date].to_date.end_of_day
        search << "deliver_logs.#{type}_at <= '#{end_date}'"
      end
    else
      if params[:begin_date].present?
        begin_date = params[:begin_date].to_date.beginning_of_day
        search << "orders.#{type}_at >= '#{begin_date}'"
      end
      if params[:end_date].present?
        end_date = params[:end_date].to_date.end_of_day
        search << "orders.#{type}_at <= '#{end_date}'"
      end
    end


    search.join ' and '
  end

  def product_type_conn type
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "orders.#{type}_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "orders.#{type}_at <= '#{end_date}'"
    end
    if params[:product_id].present?
      search << "order_products.product_id <= '#{params[:product_id]}'"
    end
    search.join ' and '
  end

  def cost_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "costs.occur_time >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "costs.occur_time <= '#{end_date}'"
    end
    if params[:user_id].present?
      search << "costs.user_id = #{params[:user_id]}"
    end
    if params[:cost_category_id].present?
      search << "costs.cost_category_id = #{params[:cost_category_id]}"
    end
    search.join ' and '
  end

  def invoice_conn
    search = ['1=1']
    if params[:begin_date].present?
      begin_date = params[:begin_date].to_date.beginning_of_day
      search << "invoices.sended_at >= '#{begin_date}'"
    end
    if params[:end_date].present?
      end_date = params[:end_date].to_date.end_of_day
      search << "invoices.sended_at <= '#{end_date}'"
    end
    if params[:user_id].present?
      search << "invoices.user_id = #{params[:user_id]}"
    end
    search.join ' and '
  end

  ####################################### end search conn #######################################


  ####################################### begin select #######################################
  def total_price
    'sum(orders.total_price) as total_price'
  end

  def total_payment
    'sum(payment_logs.amount) as total_payment, orders.* '
  end

  def total_deliver
    'sum(deliver_logs.amount) as total_amount, orders.* '
  end

  def total_cost
    # 'sum(costs.amount) as total_amount'
  end

  # def select_payment
  #   'total_price, payment_at'
  # end
  ####################################### end select ########################################



  ####################################### begin  data #######################################
  def order_data type
    if type == 'payment'
      order_scope.joins(:payment_logs).where(search_conn).where(order_type_conn type).select('payment_logs.*, payment_logs.payment_at as payment_at, payment_logs.amount as amount, orders.*')
      elsif type == 'deliver'
        order_scope.joins(:deliver_logs).where(search_conn).where(order_type_conn type).select('deliver_logs.*, deliver_logs.deliver_at as deliver_at, deliver_logs.amount as amount, orders.*')
    else
      order_scope.where(search_conn).where(order_type_conn type)
    end
  end

  def cost_data
    cost_scope.where(cost_conn)
  end

  def invoice_data
    invoice_scope.where(invoice_status: 'sended').where(invoice_conn)
  end

  def product_data type
    order_product_scope.where(product_type_conn type)
  end

  ####################################### begin  data #######################################


  ####################################### begin chat data #######################################
  def order_data_for_pie type
    if type == 'payment'
      order_data(type).unscope(:select).sum('payment_logs.amount').to_f.round 2
    elsif type == 'deliver'
      order_data(type).unscope(:select).sum('deliver_logs.amount').to_f.round 2
    else
      order_data(type).sum(:total_price).to_f.round 2
    end
  end

  def project_data_for_pie type
    order_data = order_data(type)
    # {project1 => [order1, order2], project2 => [order3, order4]}
    # byebug
    group_data = order_data.group_by{|order| order.project}
    datas = {}
    group_data.each do |project, orders|
      datas[project] = orders.sum{|order| order.amount}.round 2
    end
    datas
  end

  def category_data_for_pie type
    project_datas = project_data_for_pie type
    group_data = project_datas.group_by{|project, data| project.category}
    datas = {}
    group_data.each do |category, project_data|
      datas[category] = project_data.sum{|project, data| data}.round 2
    end
    datas
  end

  def user_data_for_pie type
    project_datas = project_data_for_pie type
    group_data = project_datas.group_by{|project, data| project.owner}
    datas = {}
    group_data.each do |user, project_data|
      datas[user] = project_data.sum{|project, data|  data}.round 2
    end
    datas
  end

  def cost_data_for_pie
    cost_datas = cost_data
    group_data = cost_datas.group_by{|cost, data| cost.user}
    datas = {}
    group_data.each do |user, cost_data|
      datas[user] = cost_data.sum{| data| data.amount}.round 2
    end
    datas
  end

  def product_data_for_pie type
    product_datas = product_data type
    # {project1 => [order1, order2], project2 => [order3, order4]}
    group_data = product_datas.group_by{|order_product| order_product.product.product_category}
    datas = {}
    group_data.each do |product_category, order_products|
      number = 0
      amount = 0
      order_products.each do |op|
        number += op.number
        amount += op.discount_total_price
      end
      datas[product_category] = {number: number, amount: amount}
    end
    datas
  end

  ###############bar
  def order_data_for_bar type
    data = order_data(type)
    data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
  end

  #{date: {category: 1}}
  def category_data_for_bar type
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      # payment 从payment_logs照片那个统计
      orders.group_by{|order| order.project.category}.each do |category, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'applied' ? 'total_price' : 'amount'}").to_f
        end
        order_datas_hash[category] = amount.round(2)
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  def product_category_data_for_bar type
    data = product_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.order.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, order_products|
      product_datas_hash = {}
      order_products.group_by{|order_product| order_product.product.product_category}.each do |category, ops|
        amount = 0
        number = 0
        ops.each do |op|
          amount += op.discount_total_price
          number += op.number
        end
        product_datas_hash[category] = {amount: amount.round(2), number: number}
      end
      date_datas_hash[date] = product_datas_hash
    end
    date_datas_hash
  end

  #############table
  def project_data_for_table type='payment'
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      orders.group_by{|order| order.project}.each do |project, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'applied' ? 'total_price' : 'amount'}").to_f
        end
        order_datas_hash[project] = amount
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  def product_data_for_table type='payment'
    data = product_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.order.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, order_products|
      order_product_datas_hash = {}
      order_products.group_by{|order_product| order_product.product}.each do |product, order_products|
        amount = 0
        number = 0
        order_products.each do |order_product|
          amount += order_product.discount_total_price.to_f
          number += order_product.number
        end
        order_product_datas_hash[product] = {amount: amount, number: number}
      end
      date_datas_hash[date] = order_product_datas_hash
    end
    date_datas_hash
  end

  def user_data_for_table type='payment'
    data = order_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.send("#{type}_at")
    end
    date_datas_hash = {}
    date_datas.each do |date, orders|
      order_datas_hash = {}
      orders.group_by{|order| order.project.owner}.each do |owner, orders|
        amount = 0
        orders.each do |order|
          amount += order.send("#{type == 'applied' ? 'total_price' : 'amount'}").to_f
        end
        order_datas_hash[owner] = amount
      end
      date_datas_hash[date] = order_datas_hash
    end
    date_datas_hash
  end

  def cost_data_for_table
    date_datas_hash = {}
    date_datas = cost_data.group_by{|cost| simple_date_time cost.occur_time}
    date_datas.each do |date, costs|
      cost_datas_hash = {}
      costs.group_by{|cost| cost.user}.each do |user, user_costs|
        amount = 0
        user_costs.each do |cost|
          amount += cost.amount
        end
        cost_datas_hash[user] = amount
      end
      date_datas_hash[date] = cost_datas_hash
    end
    date_datas_hash
  end

  def invoice_data_for_table
    date_datas_hash = {}
    date_datas = invoice_data.group_by{|invoice| simple_date_time invoice.sended_at}
    date_datas.each do |date, invoices|
      invoice_datas_hash = {}
      invoices.group_by{|invoice| invoice.user}.each do |user, user_invoices|
        amount = 0
        user_invoices.each do |invoice|
          amount += invoice.amount
        end
        invoice_datas_hash[user] = amount
      end
      date_datas_hash[date] = invoice_datas_hash
    end
    date_datas_hash
  end

  def products_data_for_table type
    data = product_data(type)
    date_datas = data.group_by do |d|
      simple_date_time d.order.send("#{type}_at")
    end
    date_datas_hash = []
    date_datas.each do |date, order_products|
      product_datas_hash = {}
      order_products.group_by{|order_product| order_product.product}.each do |product, ops|
        amount = 0
        number = 0
        ops.each do |op|
          amount += op.discount_total_price
          number += op.number
        end
        date_datas_hash = [date, product, amount.round(2), number]
      end
    end
    date_datas_hash
  end

  ####################################### end chat data #######################################



  ####################################### format chat data####################################
  def format_order_pie
    data = []
    ['applied', 'deliver', 'payment'].each do |type|
      data << order_data_for_pie(type)
    end
    data
  end

  def format_project_data_for_pie type = 'payment'
    projects_datas = project_data_for_pie(type)
    projects_pie_labels = []
    projects_pie_data = []
    projects_datas.sort{|x, y| y[1] <=> x[1] }[0..9].each do |project, data|
      projects_pie_labels << project.name
      projects_pie_data << data
    end
    return projects_pie_labels, projects_pie_data
  end

  def format_category_data_for_pie type = 'payment'
    categories_datas = category_data_for_pie(type)
    categories_pie_labels = []
    categories_pie_data = []
    categories_datas.sort{|x, y| y[1] <=> x[1] }[0..9].each do |category, data|
      categories_pie_labels << category.name
      categories_pie_data << data
    end
    return categories_pie_labels[0..9], categories_pie_data[0..9]
  end

  def format_user_data_for_pie type = 'payment'
    users_datas = user_data_for_pie(type)
    users_pie_labels = []
    users_pie_data = []
    users_datas.sort{|x, y| y[1] <=> x[1] }[0..9].each do |user, data|
      users_pie_labels << user.name
      users_pie_data << data
    end
    return users_pie_labels[0..9], users_pie_data[0..9]
  end

  def format_cost_data_for_pie
    costs_datas = cost_data_for_pie
    costs_pie_labels = []
    costs_pie_data = []
    costs_datas.sort{|x, y| y[1] <=> x[1] }[0..9].each do |user, data|
      costs_pie_labels << user.name
      costs_pie_data << data
    end
    return costs_pie_labels[0..9], costs_pie_data[0..9]
  end

  def format_product_data_for_pie type = 'payment'
    products_datas = product_data_for_pie(type)
    products_pie_labels = []
    products_pie_data = []
    products_datas.sort{|x, y| y[1][:amount] <=> x[1][:amount]}[0..9].each do |product_category, data|
      products_pie_labels << product_category.name
      products_pie_data << data[:amount]
    end
    return products_pie_labels[0..9], products_pie_data[0..9]
  end


  ### bar
  def format_order_bar type='payment'
    labels = data_label
    datas = []
    ['applied', 'deliver', 'payment'].each do |type|
      bar_data = []
      data = order_data_for_bar(type)
      labels.each do |label|
        price = 0
        if data[label].present?
          data[label].each do |d|
            price += d.send("#{type == 'applied' ? 'total_price' : 'amount'}").to_f
          end
        end
        bar_data << price.round(2)
      end
      datas << bar_data
    end
    return labels, datas
  end

  def format_category_bar type='payment'
    labels = data_label
    datas = []
    data = category_data_for_bar(type)
    bars = []
    data_label.each_with_index do |date, index|
      bar_data = []
      bars = []
      Category.all.each do |category|
        amount = 0
        amount = data[date][category].to_f if data[date].present? && data[date][category].present?
        bar_data << amount.round(2)
        bars << category.name
      end
      datas << bar_data
    end
    return labels, bars, format_arr(datas)
  end

  def format_product_category_data_for_bar type='deliver'
    labels = data_label
    datas = []
    data = product_category_data_for_bar(type)
    bars = []
    data_label.each_with_index do |date, index|
      bar_data = []
      bars = []
      ProductCategory.all.each do |product_category|
        number = 0
        number = data[date][product_category][:number] if data[date].present? && data[date][product_category].present?
        bar_data << number
        bars << product_category.name
      end
      datas << bar_data
    end
    return labels, bars, format_arr(datas)
  end


  def format_project_data_for_table type='payment'
    datas = []
    data = project_data_for_table type
    data_label.each do |date|
      project_hash = {}
      projects = Project.all
      projects = projects.where(id: params[:project_id]) if params[:project_id].present?
      projects = projects.where(company_id: params[:company_id]) if params[:company_id].present?
      projects.each do |project|
        amount = 0
        amount = data[date][project] if data[date].present? && data[date][project].present?
        # project_hash[project] = amount.round(2)
        datas << [date, project, amount.round(2)]
      end
    end
    datas
  end

  def format_product_data_for_table type='payment'
    datas = []
    data = product_data_for_table type
    data_label.each do |date|
      product_hash = {}
      products = Product.all
      products = products.where(id: params[:product_id]) if params[:product_id].present?
      products.each do |product|
        amount = 0
        number = 0
        if data[date].present? && data[date][product].present?
          amount = data[date][product][:amount]
          number = data[date][product][:number]
        end
        datas << [date, product, number, amount.round(2)] if number > 0
      end
    end
    datas
  end

  #
  def format_user_data_for_table type='payment'
    datas = []
    data = user_data_for_table type
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      user_hash = {}
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        datas << [date, user, amount.round(2)]
      end
    end
    datas
  end

  def format_cost_data_for_table
    datas = []
    data = cost_data_for_table
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        datas << [date, user, amount.round(2)] if amount > 0
      end
    end
    datas
  end

  def format_invoice_data_for_table
    datas = []
    data = invoice_data_for_table
    users = User.all
    users = User.where(id: params[:user_id]) if params[:user_id].present?
    data_label.each do |date|
      users.each do |user|
        amount = 0
        amount = data[date][user] if data[date].present? && data[date][user].present?
        datas << [date, user, amount.round(2)] if amount > 0
      end
    end
    datas
  end


  ################helper#######
  def simple_date_time datetime
    group_type = params[:group_type]
    if datetime.present?
      formats = if I18n.locale.to_s == 'en'
                  { 'day' => '%Y-%m-%d', 'month' => '%Y-%m', 'year' => '%Y' }
                else
                  { 'day' => '%Y年%m月%d日', 'month' => '%Y年%m月', 'year' => '%Y年' }
                end
      datetime.strftime(formats.fetch(group_type, formats['year']))
    end

  end


  def data_label
    begin_date = params[:begin_date].to_date.beginning_of_day
    end_date = params[:end_date].to_date.end_of_day
    begin_date.to_date.upto(end_date.to_date).group_by{|date| simple_date_time date}.keys
  end

  def set_params
    params[:group_type] ||= 'day'
    if params[:date_range].present?
      arr = params[:date_range].split(' - ')
      params[:begin_date] = arr[0].to_date
      params[:end_date] = arr[1].to_date
    else
      params[:begin_date] ||= DateTime.now
      params[:end_date] = DateTime.now
      params[:date_range] = "#{params[:begin_date].strftime('%Y-%m-%d')} - #{params[:end_date].strftime('%Y-%m-%d')}"
    end
    @organization = current_user.regional_organization
    @organization = Organization.find_by id: params[:organization_id] if  params[:organization_id].present?

  end

  def format_arr arrs
    new_array = Array.new(arrs[0].size) { Array.new(arrs.size, 0) }
    arrs.each_with_index do |arr, i|
      arr.each_with_index do |str, index|
        new_array[index][i] = str
      end
    end
    new_array
  end


  ##===========================================================================
  def order_month_amounts
    date = params[:begin_date]
    order_scope.where(search_conn).where(applied_at: date.beginning_of_month..date.end_of_month).sum(:total_price).to_f.round 2
  end

  def payment_month_amounts
    date = params[:begin_date]
    order_scope.joins(:payment_logs)
               .where(search_conn)
               .where(payment_logs: { payment_at: date.beginning_of_month..date.end_of_month })
               .sum('payment_logs.amount').to_f.round 2
  end

  def deliver_month_amounts
    date = params[:begin_date]
    order_scope.joins(:deliver_logs)
               .where(search_conn)
               .where(deliver_logs: { deliver_at: date.beginning_of_month..date.end_of_month })
               .sum('deliver_logs.amount').to_f.round 2
  end


  def need_payment_amounts
    total_payment = order_scope.joins(:payment_logs).where(search_conn).sum('payment_logs.amount').to_f.round 2
    total_deliver = order_scope.joins(:deliver_logs).where(search_conn).sum('deliver_logs.amount').to_f.round 2
    total_deliver - total_payment
  end


end
