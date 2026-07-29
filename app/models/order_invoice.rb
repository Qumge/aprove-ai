# == Schema Information
#
# Table name: order_invoices
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  invoice_id :integer
#  order_id   :integer
#

class OrderInvoice < ActiveRecord::Base
  belongs_to :order
  belongs_to :invoice
  validates_uniqueness_of :order_id
end
