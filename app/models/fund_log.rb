class FundLog < ActiveRecord::Base
	belongs_to :order
	validates_presence_of :fund_at
	belongs_to :user
	has_one :fund_file, -> {where(model_type: 'fund')}, class_name: 'Attachment', foreign_key: :model_id
	after_save :set_order 

	def set_order
		order = self.order 
		order.do_fund! if order.may_do_fund?
	end
end
