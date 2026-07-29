class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:edit, :update, :invoice_apply]
  before_action :set_project, only: [:index, :create]

  def new
    @invoice = Invoice.new
    render layout: false
  end

  def create
    @invoice = @project.invoices.new
    @invoice.user = current_user
    @flag = @invoice.update invoice_permit
  end

  def index

  end

  def show
    @invoice = Invoice.find_by id: params[:id]
    render layout: false
  end

  def edit
    render layout: false
  end

  def update
    @flag = @invoice.update invoice_permit
  end

  def invoice_apply
    @invoice.do_apply!
    render js: 'location.reload()'
  end

  private
  def set_default_invoice
    @project = current_user.view_projects.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
    if params[:invoice_id].present?
      @invoice = Invoice.where(id: params[:invoice_id], project: current_user.view_projects).first
    else
      @invoice = Invoice.new project_id: params[:id]
    end
  end

  def set_project
    @project = current_user.view_projects.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
  end

  def invoice_permit
    params.require(:invoice).permit(:amount)
  end

  def set_invoice
    @project = current_user.view_projects.find_by id: params[:id]
    @invoice = Invoice.find_by id: params[:invoice_id]
    redirect_to projects_path, alert: '找不到数据' unless @invoice.present? && @project.present?
  end
end
