class DynamicReportsController < ApplicationController
  include DynamicReport

  before_action :set_params

  def index
    @datas = []
    if params[:model_type] == 'payment'
      params[:groups] ||= ['payment_logs']
      @datas = dynamic_payment_report.page(params[:page]).per(Settings.per_page)
    elsif params[:model_type] == 'deliver'
      params[:groups] ||= ['deliver_logs']
      @datas = dynamic_deliver_report.page(params[:page]).per(Settings.per_page)
    elsif params[:model_type] == 'applied'
      params[:groups] ||= ['order_products']
      @datas = dynamic_applied_report.page(params[:page]).per(Settings.per_page)
    end
    respond_to do |format|
      format.html
      format.js
      format.xls do
        filename = I18n.t('sections.dynamic_reports.export_filename')
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}-#{Date.current}.xls\""
      end
    end

  end

  def set_params
    params[:select_columns] ||= []
    params[:begin_date], params[:end_date] = params[:date_range].split(' - ') if params[:date_range].present?
    params[:begin_date] ||= DateTime.now
    params[:end_date] ||= DateTime.now
  end
end
