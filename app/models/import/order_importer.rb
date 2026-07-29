class Import::OrderImporter < ActiveImporter::Base
  imports Product
  imports Order
  imports OrderProduct
  imports Sale
  transactional

  on :import_started do
    @row_count = 2
    @normal_order = Order.create project: params[:project], user: params[:user], order_type: 'normal'
    @bargains_order = Order.create project: params[:project], user: params[:user], order_type: 'bargains'
    logger.info "开始导入订单信息信息...."
  end
  column '订单厂商'
  column '产品名'
  column '数量'
  column '战略价'
  column '单价（特价）'
  column '金额'
  column '备注/特殊要求'



  fetch_model do
    product = Product.find_by name: row['产品名']
    raise "第#{row_count}行 #{row['产品名']}不存在。" unless product.present?
    raise "第#{row_count}行 【数量】不存在。" unless row['数量'].present? && row['数量'].to_i > 0
    #raise "第#{row_count}行 【单价（特价）】不存在。" unless row['单价（特价）'].present?
    #raise "第#{row_count}行 【金额】不存在。" unless row['金额'].present?
    product
  end

  on :row_processing do
    project = params[:project]
    product = model
    sale = product.sale project
    # sale = Sale.find_by product: product, contract: project.contracts
    if row['单价（特价）'].present?
      price = row['单价（特价）'].to_f
    else
      price = product.default_price project
    end
    if sale.present? && sale.price == price
      @normal_order.desc = "#{@normal_order.desc}#{row['备注/特殊要求']}; "
      order = @normal_order
    else
      @bargains_order.desc = "#{@bargains_order.desc}#{row['备注/特殊要求']}; "
      order = @bargains_order
    end
    if row['订单厂商'].present?
      factory = Factory.find_by name: row['订单厂商']
      if factory.present?
        order.factory = factory
      else
        raise "第#{row_count}行 【订单厂商】不存在。"
      end
    end
    number = row['数量'].to_i
    total_price = number * price
    #raise "第#{row_count}行 【金额】计算不正确。" unless  row['金额'].to_f == total_price
    order_product = OrderProduct.new order: order, product: product, number: number, price: product.default_price(project), total_price: number * product.default_price(project),
                             discount_price: price, discount_total_price: total_price
    order_product.skip_before_save = true
    unless order_product.save
      error = product.errors.messages.first
      raise "第#{row_count}行 #{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
    end

  end

  on :row_processed do
    @row_count += 1
  end

  on :row_error do |e|
    logger.error e.message
  end

  on :import_failed do |exception|
    logger.error exception.message
  end

  on :import_finished do
    if @bargains_order.order_products.present?
      unless @bargains_order.save
        error = @bargains_order.errors.messages.first
        raise "#{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
      end
    else
      @bargains_order.destroy
    end

    if @normal_order.order_products.present?
      unless @normal_order.save
        error = @normal_order.errors.messages.first
        raise "#{I18n.t "activerecord.attributes.product.#{error.first.to_s}"}: #{error[1][0].to_s}"
      end
    else
      @normal_order.destroy
    end

    logger.info "#{@row_count} lines Data imported successfully!"
  end

  private

  def logger
    Logger.new "log/product_import.log"
  end
end
