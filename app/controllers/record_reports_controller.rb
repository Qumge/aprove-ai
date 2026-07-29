class RecordReportsController < ApplicationController
  before_action :set_params
  include ReportData
  def index
    @orders_pie_labels = %w[ordered_amount delivered_amount payment_amount].map { |key| I18n.t("sections.reports.#{key}") }
    @orders_pie_data = format_order_pie

    @projects_pie_labels, @projects_pie_data = format_project_data_for_pie('payment')

    @categories_pie_labels, @categories_pie_data = format_category_data_for_pie('payment')

    @users_pie_labels, @users_pie_data = format_user_data_for_pie('payment')

    @costs_pie_labels, @costs_pie_data = format_cost_data_for_pie

    @products_pie_labels, @products_pie_data = format_product_data_for_pie 'applied'

    @chatColor = ['#00a65a', '#dd4b39', '#00c0ef', '#f39c12', '#3c8dbc', '#ff0084', '#205081', '#f94877', '#001f3f','#d2d6de']
    @order_month_amounts = order_month_amounts
    @deliver_month_amounts = deliver_month_amounts
    @payment_month_amounts =  payment_month_amounts
    @need_payment_amounts = need_payment_amounts

  end


  def orders
    @orders_bar_labels, @orders_bar_data = format_order_bar
    @orders_bar_bars = %w[ordered_amount delivered_amount payment_amount].map { |key| I18n.t("sections.reports.#{key}") }
    @order_array = Kaminari.paginate_array(@orders_bar_labels).page(params[:page]).per(Settings.per_page)
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.order_report')}-#{Date.today}.xls\""
      end
    end

  end


  def projects
    @projects_bar_labels, @projects_bar_bars, @projects_bar_data = format_category_bar 'payment'
    @table_data = format_project_data_for_table 'payment'
    @projects_array = Kaminari.paginate_array(@table_data).page(params[:page]).per(Settings.per_page)
    @applied_hash = project_data_for_table 'applied'
    @deliver_hash = project_data_for_table 'deliver'
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.project_report')}-#{Date.today}.xls\""
      end
    end
  end

  def products
    @products_bar_labels, @products_bar_bars, @products_bar_data = format_product_category_data_for_bar 'applied'
    @table_data = format_product_data_for_table 'applied'
    @products_array = Kaminari.paginate_array(@table_data).page(params[:page]).per(Settings.per_page)
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.product_report')}-#{Date.today}.xls\""
      end
    end
  end


  def users
    #@projects_array = Kaminari.paginate_array(project_data_for_table 'payment').page(params[:page]).per(Settings.per_page)
    #@projects_bar_labels, @projects_bar_bars, @projects_bar_data = format_category_bar 'payment'
    #
    @table_data = format_user_data_for_table 'payment'
    @users_array = Kaminari.paginate_array(@table_data).page(params[:page]).per(Settings.per_page)
    @applied_hash = user_data_for_table 'applied'
    @deliver_hash = user_data_for_table 'deliver'
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.performance_report')}-#{Date.today}.xls\""
      end
    end
  end

  def costs
    @table_data = format_cost_data_for_table
    @costs_array = Kaminari.paginate_array(@table_data).page(params[:page]).per(Settings.per_page)
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.expense_report')}-#{Date.today}.xls\""
      end
    end
  end

  def invoices
    @table_data = format_invoice_data_for_table
    @invoices_array = Kaminari.paginate_array(@table_data).page(params[:page]).per(Settings.per_page)
    respond_to do |format|
      format.html
      format.js
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{I18n.t('sections.reports.invoice_report')}-#{Date.today}.xls\""
      end
    end
  end

end
