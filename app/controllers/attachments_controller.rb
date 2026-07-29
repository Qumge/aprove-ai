class AttachmentsController < ApplicationController

  def index
    @attachments = Attachment.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
  end

  def destroy
    @attachment = Attachment.find_by id: params[:id]
    if @attachment.destroy
      redirect_to attachments_path, notice: '删除成功'
    else
      redirect_to attachments_path, alert: '删除失败'
    end
  end
end
