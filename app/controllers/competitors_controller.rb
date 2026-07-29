class CompetitorsController < ApplicationController
  before_action :set_competitor,  only: [:edit, :update, :destroy]
  include ApplicationHelper

  def index
    @competitors = Competitor.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @competitor = Competitor.new
    render layout: false
  end

  def create
    @competitor = Competitor.new user: current_user
    @competitor.name = params[:competitor_name]
    @competitor.build_attachment path: params[:path], file_name: params[:file_name]
    @flag = @competitor.save

  end

  def edit
    render layout: false
  end

  def update
    @competitor.user = current_user
    @competitor.name = params[:competitor_name]
    @competitor.build_attachment path: params[:path], file_name: params[:file_name]
    @flag = @competitor.save
    render template: 'competitors/create'
  end

  def destroy
    if @competitor.destroy
      redirect_to competitors_path, notice: '删除成功'
    else
      redirect_to competitors_path, alert: '删除失败'
    end
  end

  private
  def set_competitor
    @competitor = Competitor.find_by id: params[:id]
    redirect_to competitors_path, alert: '找不到数据' unless @competitor.present?
  end

end
