class AgentsController < ApplicationController
  before_action :set_agent, only: [:show]
  def index
    @agents = Agent.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @agent = Agent.new
  end

  def show
    render layout: false
  end

  def create
    @agent = Agent.new agent_permit
    @agent.apply_user = current_user
    if @agent.save
      redirect_to agents_path, notice: '已提交申请'
    else
      render :new
    end
  end

  private
  def agent_permit
    params.require(:agent).permit(:username, :city, :name, :phone, :business, :resources, :scale, :members, :product, :achievement, :desc)
  end

  def set_agent
    @agent = Agent.find_by id: params[:id]
    redirect_to agents_path, alert: '找不到数据' unless @agent.present?
  end

end
