class ManageInvoicesController < ApplicationController
  include ApplicationHelper
  before_action :set_invoice, only: [:upload_file]

  def index
    @invoices = Invoice.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
  end

  def upload_file
    if @invoice.invoice_file.present?
      @invoice.invoice_file.update file_name: params[:file_name], path: params[:path]
    else
      @invoice.create_invoice_file file_name: params[:file_name], path: params[:path]
    end
    render js: 'location.reload()'
  end

  private

  def set_invoice
    @invoice = Invoice.find_by id: params[:id]
    redirect_to manage_invoices_path unless @invoice.present?
  end
end
