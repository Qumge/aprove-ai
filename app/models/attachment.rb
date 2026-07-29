# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  file_name  :string(255)
#  model_type :string(255)
#  path       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer
#
# Indexes
#
#  index_attachments_on_deleted_at  (deleted_at)
#

class Attachment < ActiveRecord::Base

  after_create :do_order

  def preview_url
    ObjectStorage.url(path)
  end

  # 上传完图片后 执行order的操作
  def do_order
    # if self.model_type == 'sign'
    #   order = Order.find_by id: model_id
    #   order.do_sign! if order.may_do_sign?
    if self.model_type == 'invoice'
      invoice = Invoice.find_by id: model_id
      invoice.do_sended! if invoice.may_do_sended?
    end

  end

  class << self
    def search_conn params
      attachments = Attachment.all
      begin_date = DateTime.now.beginning_of_day
      end_date = DateTime.now.end_of_day
      if params[:date_range].present?
        arr = params[:date_range].split(' - ')
        params[:begin_date] = arr[0].to_date
        params[:end_date] = arr[1].to_date
        begin_date = params[:begin_date].to_date.beginning_of_day
        end_date = params[:end_date].to_date.end_of_day
      end
      attachments = attachments.where(created_at: begin_date...end_date)

      if params[:model_type].present?
        attachments = attachments.where(model_type: params[:model_type])
      end

      if params[:table_search].present?
        attachments = attachments.where('file_name like ?', "%#{params[:table_search]}%")
      end
      attachments
    end

    def model_types
      {place: '订货单', deliver: '发货单', sign: '签收单', contract: '项目合同文件', advance: '预付请款资料', payment: '进度款请款资料', settlement: '结算款资料', bond: '尾款资料',
       train: '培训资料', competitor: '竞品信息', invoice: '发票'
      }
    end
  end


end
