# == Schema Information
#
# Table name: product_categories
#
#  id         :integer          not null, primary key
#  desc       :text(65535)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductCategory < ActiveRecord::Base
  has_many :products
  validates_presence_of :name
  PRODUCT_CATEGORY = ['铝扣板', '浴霸', '开关', '照明', '水管']


  class << self
    def load!
      PRODUCT_CATEGORY.each do |category|
        self.find_or_create_by name: category
      end
    end
  end
end
