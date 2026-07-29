class SignLog < ActiveRecord::Base
	belongs_to :order
	validates_presence_of :sign_at
	belongs_to :user
	has_one :sign_file, -> {where(model_type: 'sign')}, class_name: 'Attachment', foreign_key: :model_id
	after_save :set_order 

	def set_order
		order = self.order 
		order.do_sign! if order.may_do_sign?
	end
end
