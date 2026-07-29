class Import::SaleImporter < ActiveImporter::Base
  imports Sale
  transactional

  on :import_started do
    @row_count = 2
    logger.info "开始导入合同价信息...."
  end

  column '产品名'
  column '价格'
  column '备注'




  fetch_model do
    raise "第#{row_count}行 产品名不存在。" unless row['产品名'].present?
    product = Product.find_by name: row['产品名']
    raise "第#{row_count}行 #{row['产品名']}不存在。" unless product.present?
    sale = Sale.find_or_initialize_by product: product, contract: params[:contract]
    sale
  end

  on :row_processing do
    sale = model
    raise "第#{row_count}行 价格不存在。" unless row['价格'].present?
    unless sale.update price: row['价格'], desc: row['备注']
      error = sale.errors.messages.first
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
    logger.info "#{@row_count} lines Data imported successfully!"
  end

  private

  def logger
    Logger.new "log/sale_import.log"
  end
end
