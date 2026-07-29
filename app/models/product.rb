# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  acquisition_price   :float(24)
#  brand               :string(255)
#  color               :string(255)
#  deleted_at          :datetime
#  desc                :text(65535)
#  freight             :float(24)
#  market_price        :float(24)
#  name                :string(255)
#  no                  :string(255)
#  norms               :string(255)
#  product_no          :string(255)
#  reference_price     :float(24)
#  unit                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :integer
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#

class Product < ActiveRecord::Base
  has_many :sales
  has_many :order_products
  has_and_belongs_to_many :orders, join_table: 'order_products'
  has_one :sale, ->(sale) { where("project_id = ?", sale.project_id) }
  belongs_to :product_category
  validates_presence_of :no, :product_no, :name, :product_category_id#, :reference_price
  validates_uniqueness_of :no, if: proc{|product| product.no.present?}
  validates_uniqueness_of :name, if: proc{|product| product.no.present?}
  validates_numericality_of :reference_price, greater_than: 0
  before_save :set_price

  def set_price
    self.reference_price = self.reference_price.round 2
  end


  def default_price project
    price = self.reference_price
    if project.contract.present?
      sale = self.sale project
      price = sale.price if sale.present?
    end
    price.to_f
  end

  def sale project
    Sale.joins({contract: :projects}, :product).where('projects.id = ? and products.id = ?', project.id, self.id).first
    #sale = project.contract.sales.find_by(product_id: self.id)
  end

  class << self
    def search_conn params
      products = Product.all
      if params[:table_search].present?
        products = products.where('no like ? or name like ? or product_no like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      products
    end
  end

end
