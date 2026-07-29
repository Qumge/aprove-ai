class Import::ProductImporter < ActiveImporter::Base
  imports Product
  transactional

  on :import_started do
    @row_count = 2
    logger.info "开始导入产品信息信息...."
  end
  column '产品代码'
  column '产品名'
  column '产品型号'
  column '产品类型'
  column '价格'
  column '单位'
  column '品牌'
  column '规格尺寸'
  column '市场价'
  column '集采价'
  column '运费'
  column '外观颜色'
  column '备注'



  fetch_model do
    product = Product.find_or_initialize_by no: row['产品代码']
    product
  end

  on :row_processing do
    product = model
    category = ProductCategory.find_by name: row['产品类型']
    raise "第#{row_count}行 #{row['产品类型']}不存在。" unless category.present?
    product.no = row['产品代码']
    product.name = row['产品名']
    product.product_no = row['产品型号']
    product.product_category = category
    product.reference_price = row['价格']
    product.unit = row['单位']
    product.brand = row['品牌']
    product.norms = row['规格尺寸']
    product.market_price = row['市场价']
    product.acquisition_price = row['集采价']
    product.freight = row['运费']
    product.color = row['外观颜色']
    product.desc = row['备注']
    unless product.save
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
    logger.info "#{@row_count} lines Data imported successfully!"
  end

  private

  def logger
    Logger.new "log/product_import.log"
  end
end
