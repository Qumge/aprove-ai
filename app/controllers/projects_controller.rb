class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :upload, :update_agency, :edit_information, :update_information, :edit_owner, :update_owner,
                                     :delete_attachment, :payment, :done, :step_event, :agent, :sales, :report,
                                     :order_import, :do_import, :show_money, :edit, :update, :reapply, :contract_order, :do_contract_order]
  include ApplicationHelper
  def index
    project_order = Arel.sql('projects.payment_percent IS NULL, projects.payment_percent ASC, projects.created_at DESC')
    @projects = current_user.view_projects.search_conn(params).order(project_order).page(params[:page]).per(Settings.per_page)
  end

  def new
    @project = Project.new
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @flag =  @project.update project_permit
  end

  def create
    @project = Project.new
    @project.owner = current_user
    @project.create_user = current_user
    if @project.update project_permit
      redirect_to projects_path, notice: '已立项，等待审批'
    else
      render :new
    end
  end

  # 添加操作模式
  def update_agency
    @flag = @project.update agency_id: params[:agency_id]
    render template: 'projects/reload_process'
  end

  def reapply
    if @project.may_do_apply?
      @project.do_apply!
    end
  end

  # 添加项目资料
  def edit_information
    render layout: false
  end

  # 添加项目资料
  def update_information
    @flag = @project.update information_permit
  end

  # 变更负责人
  def edit_owner
    render layout: false
  end

  # 添加项目资料
  def update_owner
    @flag = @project.update owner_permit
  end

  # 上传各类文件资料
  def upload
    @flag = true
    if params[:name].include?('order')
      type, id, a_type = params[:name].split('_')
      a_type = "#{a_type}_file"
      order = @project.orders.find_by id: id
      if a_type == 'sign_file'
        #@flag = order.sign_files.create file_name: params[:file_name], path: params[:path]
      else
        if order.send(a_type).present?
          @flag = order.send(a_type).update file_name: params[:file_name], path: params[:path]
        else
          @flag = order.send("create_#{a_type}", ({file_name: params[:file_name], path: params[:path]}))
        end
      end

    else
      if ['project_contract', 'advance', 'bond'].include? params[:name]
        if @project.send(params[:name]).present?
          @flag = @project.send(params[:name]).update file_name: params[:file_name], path: params[:path]
        else
          @flag = @project.send("create_#{params[:name]}", {file_name: params[:file_name], path: params[:path]})
        end
      elsif ['payments', 'settlements'].include? params[:name]
        @flag = @project.send(params[:name]).create(file_name: params[:file_name], path: params[:path])
      else
        @flag = false
      end
    end
    render template: 'projects/reload_process'
  end

  # 删除项目资料
  def delete_attachment
    @attachment = @project.attachments.find_by id: params[:attachment_id]
    redirect_to projects_path, alert: '找不到数据' unless @attachment.present?
    @attachment.destroy
    render template: 'projects/reload_process'
  end

  # 回款金额确认
  def payment
    @project.done_payment!
    #@project.update payment: params[:payment]
    render template: 'projects/reload_process'
  end


  # 下一步事件
  def step_event
    event = params[:event].to_s
    permitted_events = @project.aasm(:step_status).events(permitted: true).map { |item| item.name.to_s }
    @flag = permitted_events.include?(event) &&
            @project.aasm(:step_status).fire(event.to_sym) &&
            @project.save
  rescue AASM::InvalidTransition
    @flag = false
  end

  def agent

  end

  def report

  end

  def sales
    @sales = @project.contract_sales
    #@products = Product.all.page(params[:page]).per(Settings.per_page)
  end

  def order_import
    render layout: false
  end

  def do_import
    begin
      Import::OrderImporter.import(params[:file].path, params: {project: @project, user: current_user}) if params[:file]
     redirect_to project_path(@project), notice: '导入成功！'
    rescue => e
     redirect_to project_path(@project), alert: e.message
    end
  end

  def show_money
    render layout: false
  end

  def contract_order
    @order = @project.normal_orders.new
  end

  def do_contract_order
    @order = @project.normal_orders.new
    params[:numbers] ||= []
    params[:numbers].each do |key, value|
      if value.present?
        product = Product.find_by id: key.gsub('product_', '')
        unless product.present?
          redirect_to project_path(@project), alert: '产品不存在'
        end
        sale = product.sale @project
        unless sale.present?
          redirect_to project_path(@project), alert: '集采价不存在'
        end
        order_product = OrderProduct.new product: product, number: value
        @order.order_products << order_product
        p @order.order_products
      end
    end
    if @order.order_products.present?
      @order.user = current_user
      if @order.update order_permit
        redirect_to project_path(@project), notice: '订单创建成功'
      else
        redirect_to project_path(@project), alert: '订单创建失败'
      end
    else
      redirect_to project_path(@project), alert: '空订单'
    end
  end

  private
  def project_permit
    params.require(:project).permit(:name, :company_id, :category_id, :address, :city, :supplier_type, :strategic, :estimate,
                                    :butt_name, :butt_title, :butt_phone, contract_ids: [])
  end

  def set_project
    @project = current_user.view_projects.find_by_id params[:id]
    redirect_to projects_path, alert: '找不到这个项目' unless @project.present?
  end

  def information_permit
    params.require(:project).permit(:purchase, :purchase_phone, :design, :design_phone, :cost, :cost_phone, :settling,
                                    :settling_phone, :constructor, :constructor_phone, :supervisor, :supervisor_phone)
  end

  def owner_permit
    params.require(:project).permit(:owner_id)
  end

  def order_permit
    params.require(:order).permit(:desc, :factory_id)
  end



end
