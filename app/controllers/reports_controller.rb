class ReportsController < ApplicationController

  before_action :set_project, only: [:new, :create, :edit, :update]

  def new
    @report = Report.new project_id: params[:id], user_id: current_user.id
    render layout: false
  end

  def create
    @report = Report.new project_id: params[:id], user_id: current_user.id
    @flag = @report.update report_permit
  end

  def edit
    @report = @project.report
    render layout: false
  end

  def update
    @report = Report.find_by id: params[:id]
    @flag = @report.update report_permit
  end


  private

  def set_project
    @project = Project.find_by id: params[:id]
    redirect_to projects_path, alert: '找不到数据' unless @project.present?
  end

  def report_permit
    params.require(:report).permit(:name, :address, :builder, :project_type, :project_step, :purchase_type, :scale, :product, :supply_time, :source, :desc, :phone)
  end

end
