# == Schema Information
#
# Table name: order_products
#
#  id                   :integer          not null, primary key
#  deleted_at           :datetime
#  discount             :float(24)        default(1.0)
#  discount_price       :float(24)
#  discount_total_price :float(24)
#  number               :integer
#  price                :float(24)
#  total_price          :float(24)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  order_id             :integer
#  product_id           :integer
#
# Indexes
#
#  index_order_products_on_deleted_at  (deleted_at)
#

class OrderProduct < ActiveRecord::Base
  attr_accessor :skip_before_save
  belongs_to :product
  belongs_to :order
  has_one :sale
  validates_presence_of :number, :product_id#, :discount
  before_save :set_price, :unless => :skip_before_save
  validates_numericality_of :number, only_integer: true, if: ->(order_project) { order_project.number.present? }
  validates_numericality_of :discount, greater_than_or_equal_to: 0, if: ->(order_project) { order_project.discount.present? }


  def real_price
    discount_price.present? ? discount_price : price
  end

  def real_total_price
    discount_total_price.present? ? discount_total_price : total_price
  end

  # def sale
  #   self.product.sale self.order.project
  # end

  def set_price
    self.price = product.default_price self.order.project if self.price.blank?
    self.total_price = price * number
    self.discount_price = discount * price
    self.discount_total_price = discount_price * number
  end

  def contract_sale_price
    self.product.default_price self.order.project
  end

end
