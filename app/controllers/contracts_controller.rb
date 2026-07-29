class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update]
  def index
    @contracts = Contract.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new
    @contract.attributes = contract_permit
    if @contract.save
      redirect_to contracts_path, notice: '添加成功'
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    @contract.attributes = contract_permit
    if @contract.save
      redirect_to contracts_path, notice: '修改成功'
    else
      render :edit
    end
  end

  private
  def contract_permit
    params.require(:contract).permit(:no, :name, :partner, :product, :valid_date, :cycle, :advance_time,
                                     :process_time, :settlement_time, :tail_time, :others)
  end

  def set_contract
    @contract = Contract.includes(sales: :product).find_by id: params[:id]
    redirect_to contracts_path, alert: '找不到数据' unless @contract.present?
  end



end
