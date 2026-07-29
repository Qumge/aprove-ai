class CostsController < ApplicationController

  before_action :set_cost,  only: [:edit, :update, :destroy]

  def index
    @costs = current_user.view_costs.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @cost = Cost.new
    render layout: false
  end

  def create
    @cost = Cost.new
    @flag = @cost.update cost_permit
  end

  def edit
    render layout: false
  end

  def update
    @flag = @cost.update cost_permit
  end

  def destroy
    if @cost.destroy
      redirect_to costs_path, notice: '删除成功'
    else
      redirect_to costs_path, alert: '删除失败'
    end
  end

  private
  def set_cost
    @cost = Cost.find_by id: params[:id]
    redirect_to costs_path, alert: '找不到数据' unless @cost.present?
  end

  def cost_permit
    params.require('cost').permit(:user_id, :amount, :purpose, :occur_time, :cost_category_id)
  end

end
