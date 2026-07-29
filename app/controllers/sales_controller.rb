
class SalesController < ApplicationController
  before_action :set_default_sale, only: [:new, :create, :sale_import, :do_import]
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  def new
    render layout: false
  end

  def show
    render layout: false
  end

  def create
    @flag = @sale.update sale_permit
    @sales = Sale.where(contract_id: params[:id])
  end

  def edit
    render layout: false
  end

  def update
    @flag = @sale.update sale_permit
    @sales = Sale.where(contract_id: @sale.contract_id)
  end

  def destroy
    if @sale.destroy
      redirect_to contract_path(@sale.contract_id), notice: '删除成功'
    else
      redirect_to contract_path(@sale.contract_id), alert: '删除失败'
    end
  end

  def sale_import
    render layout: false
  end

  def do_import
    begin
      Import::SaleImporter.import(params[:file].path, params: {contract: @contract}) if params[:file]
      redirect_to contract_path(@contract), notice: '导入成功！'
    rescue => e
      redirect_to contract_path(@contract), alert: e.message
    end
  end

  private
  def set_default_sale
    @contract = Contract.find_by id: params[:id]
    redirect_to contracts_path, alert: '找不到数据' unless @contract.present?
    @sale = Sale.new contract_id: params[:id]
  end

  def set_sale
    @sale = Sale.find_by id: params[:id]
    redirect_to contracts_path, alert: '找不到数据' unless @sale.present?
  end

  def sale_permit
    params.require('sale').permit(:product_id, :price)
  end
end
