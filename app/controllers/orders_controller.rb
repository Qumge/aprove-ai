class OrdersController < ApplicationController
  before_action :set_default_order, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  after_action :reload_project, only: [:update, :create]
  before_action :greater, only: [:create, :update]
  def new
    @order_product = OrderProduct.new
    render layout: false
  end


  def create
    @order.order_type = params[:type]
    @order_product = @order.order_products.new order_product_permit
    @order.desc = params[:desc] if params[:desc].present?
    @order.factory_id = params[:factory_id] if params[:factory_id].present?
    @flag = @order.save
  end

  def edit
    render layout: false
  end

  def update
    @flag = @order_product.update order_product_permit
  end

  def destroy
    if @order_product.destroy
      redirect_to project_path @project
    end
  end

  def apply_order
    @order = Order.find_by id: params[:order_id]
    redirect_to projects_path, alert: '找不到数据' unless @order.present?
    @order.do_apply
    @order.save
    @project = @order.project
  end

  def place_order
    @order = Order.find_by id: params[:order_id]
    redirect_to projects_path, alert: '找不到数据' unless @order.present?
    if @order.order_type == 'normal'
      @order.do_place
    elsif @order.order_type == 'bargains'
      @order.do_apply
    end
    @order.save
    @project = @order.project
  end

  private
  def greater
    unless current_user.is_rear?
      if params[:order_product].present? && !(params[:order_product][:number].to_i > 0)
        render js: "alert('请勿输入负数');"
        return
      end
    end
  end

  def set_default_order
    @project = current_user.view_projects.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
    if params[:order_id].present?
      @order = Order.where(id: params[:order_id], project: current_user.view_projects).first
    else
      @order = Order.new project_id: params[:id], user_id: current_user.id
      if @project.plate?
        @order.order_type = 'sample'
      elsif @project.order?
        @order.order_type = 'normal'
      end
    end
  end

  def set_order
    @order_product = OrderProduct.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @order_product.present?
    @order = @order_product.order
    @project = @order_product.order.project
    redirect_to projects_path, alert: '找不到数据' unless current_user.view_projects.include? @project
  end

  def order_product_permit
    params.require(:order_product).permit(:product_id, :number, :desc, :discount)
  end

  def reload_project
    @project.reload
  end
end
